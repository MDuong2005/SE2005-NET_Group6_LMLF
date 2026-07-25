'use strict';

const contextPath = document.body.dataset.contextPath || '';
const initialJsonElement = document.getElementById('initialJson');
const editorForm = document.getElementById('editorForm');
const editorJson = document.getElementById('editorJson');
const coBody = document.getElementById('coBody');
const cloBody = document.getElementById('cloBody');
const taskBody = document.getElementById('taskBody');
const resourceBody = document.getElementById('resourceBody');
const scheduleBody = document.getElementById('scheduleBody');
const assessmentBody = document.getElementById('assessmentBody');
const coMappingContainer = document.getElementById('coMappingContainer');
const mappingContainer = document.getElementById('mappingContainer');
const weightTotal = document.getElementById('weightTotal');
const validationSummary = document.getElementById('validationSummary');

let data = JSON.parse(initialJsonElement.value || '{}');

data.generalInformation = data.generalInformation || {};
data.courseObjectives = data.courseObjectives || [];
data.clos = data.clos || [];
data.studentTasks = data.studentTasks || [];
data.learningResources = data.learningResources || [];
data.scheduleItems = data.scheduleItems || [];
data.assessments = data.assessments || [];
data.curriculumPloGroups = data.curriculumPloGroups || [];
data.plos = data.plos || [];
data.cloCoMappings = data.cloCoMappings || {};
data.cloPloMappings = data.cloPloMappings || {};

/* Backward compatibility for data created before curriculum grouping. */
if (data.curriculumPloGroups.length === 0 && data.plos.length > 0) {
    data.curriculumPloGroups = [{
        curriculumId: null,
        curriculumCode: 'LEGACY',
        curriculumName: 'Legacy PLO Data',
        semester: null,
        plos: data.plos
    }];
}

const esc = value => String(value ?? '').replace(
    /[&<>"']/g,
    character => ({
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#39;'
    }[character])
);

function normalizeCode(value, prefix) {
    const match = String(value || '').trim().match(new RegExp('^' + prefix + '\\s*0*(\\d+)$', 'i'));
    return match ? prefix.toUpperCase() + Number(match[1]) : null;
}

function bindGeneral() {
    const general = data.generalInformation;

    [
        'courseCode',
        'courseName',
        'credits',
        'degreeLevel',
        'timeAllocation',
        'prerequisiteText',
        'courseDescription'
    ].forEach(key => {
        const element = document.getElementById(key);
        if (element) {
            element.value = general[key] ?? '';
        }
    });
}

function rowInput(value, className, type = 'text') {
    return `<input type="${type}" class="${className}" value="${esc(value)}">`;
}

function rowText(value, className) {
    return `<textarea class="${className}">${esc(value)}</textarea>`;
}

function captureCurrentMappingSelections() {
    const coMappings = {};
    document.querySelectorAll('.co-mapping-check:checked').forEach(checkbox => {
        const cloCode = checkbox.dataset.clo;
        const coCode = checkbox.dataset.co;
        if (!cloCode || !coCode) return;
        if (!coMappings[cloCode]) coMappings[cloCode] = [];
        if (!coMappings[cloCode].includes(coCode)) coMappings[cloCode].push(coCode);
    });
    if (document.querySelector('.co-mapping-check')) {
        data.cloCoMappings = coMappings;
    }

    const ploMappings = {};
    document.querySelectorAll('.mapping-check:checked').forEach(checkbox => {
        const cloCode = checkbox.dataset.clo;
        const ploId = Number(checkbox.dataset.plo);
        if (!cloCode || !Number.isFinite(ploId)) return;
        if (!ploMappings[cloCode]) ploMappings[cloCode] = [];
        if (!ploMappings[cloCode].includes(ploId)) ploMappings[cloCode].push(ploId);
    });
    if (document.querySelector('.mapping-check')) {
        data.cloPloMappings = ploMappings;
    }
}

function addCo(item = {
    code: 'CO' + (data.courseObjectives.length + 1),
    description: ''
}) {
    captureCurrentMappingSelections();
    data.courseObjectives.push(item);
    renderCos();
    renderCloCoMapping();
    updateSectionProgress();
}

function handleCoCodeChange(index, newValue) {
    captureCurrentMappingSelections();
    const co = data.courseObjectives[index];
    if (!co) return;

    const oldCode = co.code || '';
    const newCode = String(newValue || '').trim();

    Object.keys(data.cloCoMappings || {}).forEach(cloCode => {
        data.cloCoMappings[cloCode] = (data.cloCoMappings[cloCode] || [])
            .map(code => code === oldCode ? newCode : code);
    });

    co.code = newCode;
    renderCloCoMapping();
    updateSectionProgress();
}

function removeCo(index) {
    captureCurrentMappingSelections();
    const removed = data.courseObjectives[index];
    if (removed && removed.code) {
        Object.keys(data.cloCoMappings || {}).forEach(cloCode => {
            data.cloCoMappings[cloCode] = (data.cloCoMappings[cloCode] || [])
                .filter(code => code !== removed.code);
        });
    }
    data.courseObjectives.splice(index, 1);
    renderCos();
    renderCloCoMapping();
    updateSectionProgress();
}

function renderCos() {
    if (!coBody) return;
    coBody.innerHTML = data.courseObjectives.map((item, index) => `
        <tr>
            <td>
                <input type="text"
                       class="co-code"
                       value="${esc(item.code)}"
                       onchange="handleCoCodeChange(${index}, this.value)">
            </td>
            <td>${rowText(item.description, 'co-description')}</td>
            <td>
                <button type="button"
                        class="btn-remove"
                        onclick="removeCo(${index})">
                    <i class="bi bi-trash"></i>
                </button>
            </td>
        </tr>
    `).join('');
}

function handleCloCodeChange(index, newValue) {
    captureCurrentMappingSelections();
    const clo = data.clos[index];
    if (!clo) return;

    const oldCode = clo.code || '';
    const newCode = String(newValue || '').trim();

    if (oldCode !== newCode && data.cloCoMappings[oldCode]) {
        data.cloCoMappings[newCode] = data.cloCoMappings[oldCode];
        delete data.cloCoMappings[oldCode];
    }
    if (oldCode !== newCode && data.cloPloMappings[oldCode]) {
        data.cloPloMappings[newCode] = data.cloPloMappings[oldCode];
        delete data.cloPloMappings[oldCode];
    }

    clo.code = newCode;
    renderCloCoMapping();
    renderMapping();
    updateSectionProgress();
}

function addClo(item = {
    code: 'CLO' + (data.clos.length + 1),
    description: '',
    bloomLevel: ''
}) {
    captureCurrentMappingSelections();
    data.clos.push(item);
    renderClos();
    renderCloCoMapping();
    renderMapping();
    updateSectionProgress();
}

function removeClo(index) {
    captureCurrentMappingSelections();
    const removed = data.clos[index];
    if (removed && removed.code) {
        delete data.cloCoMappings[removed.code];
        delete data.cloPloMappings[removed.code];
    }
    data.clos.splice(index, 1);
    renderClos();
    renderCloCoMapping();
    renderMapping();
    updateSectionProgress();
}

function renderClos() {
    cloBody.innerHTML = data.clos.map((item, index) => `
        <tr>
            <td>
                <input type="text"
                       class="clo-code"
                       value="${esc(item.code)}"
                       onchange="handleCloCodeChange(${index}, this.value)">
            </td>
            <td>${rowText(item.description, 'clo-description')}</td>
            <td>
                <select class="clo-bloom">
                    <option></option>
                    ${[
                        'Remember', 'Understand', 'Apply',
                        'Analyze', 'Evaluate', 'Create'
                    ].map(value => `
                        <option ${item.bloomLevel === value ? 'selected' : ''}>
                            ${value}
                        </option>
                    `).join('')}
                </select>
            </td>
            <td>
                <button type="button"
                        class="btn-remove"
                        onclick="removeClo(${index})">
                    <i class="bi bi-trash"></i>
                </button>
            </td>
        </tr>
    `).join('');
}

function addTask(item = {content: ''}) {
    data.studentTasks.push(item);
    renderTasks();
    updateSectionProgress();
}

function renderTasks() {
    taskBody.innerHTML = data.studentTasks.map((item, index) => `
        <tr>
            <td>${index + 1}</td>
            <td>${rowText(item.content, 'task-content')}</td>
            <td>
                <button type="button"
                        class="btn-remove"
                        onclick="data.studentTasks.splice(${index}, 1); renderTasks(); updateSectionProgress();">
                    <i class="bi bi-trash"></i>
                </button>
            </td>
        </tr>
    `).join('');
}

function addResource(item = {
    category: 'OTHER', title: '', author: '', url: '', description: ''
}) {
    data.learningResources.push(item);
    renderResources();
    updateSectionProgress();
}

function renderResources() {
    resourceBody.innerHTML = data.learningResources.map((item, index) => `
        <tr>
            <td>
                <select class="res-category">
                    ${['MAIN', 'REFERENCE', 'SLIDE', 'CMS', 'OTHER']
                        .map(value => `
                            <option ${item.category === value ? 'selected' : ''}>
                                ${value}
                            </option>
                        `).join('')}
                </select>
            </td>
            <td>${rowText(item.title, 'res-title')}</td>
            <td>${rowText(item.author, 'res-author')}</td>
            <td>${rowText(item.url, 'res-url')}</td>
            <td>${rowText(item.description, 'res-description')}</td>
            <td>
                <button type="button"
                        class="btn-remove"
                        onclick="data.learningResources.splice(${index}, 1); renderResources(); updateSectionProgress();">
                    <i class="bi bi-trash"></i>
                </button>
            </td>
        </tr>
    `).join('');
}

function addSchedule(item = {
    sessionNumber: data.scheduleItems.length + 1,
    category: '', topic: '', cloCodes: '', ituLevel: '', materials: '', activities: ''
}) {
    data.scheduleItems.push(item);
    renderSchedule();
    updateSectionProgress();
}

function renderSchedule() {
    scheduleBody.innerHTML = data.scheduleItems.map((item, index) => `
        <tr>
            <td>${rowInput(item.sessionNumber, 'sch-session', 'number')}</td>
            <td>${rowText(item.category, 'sch-category')}</td>
            <td>${rowText(item.topic, 'sch-topic')}</td>
            <td>${rowText(item.cloCodes, 'sch-clos')}</td>
            <td>${rowInput(item.ituLevel, 'sch-itu')}</td>
            <td>${rowText(item.materials, 'sch-materials')}</td>
            <td>${rowText(item.activities, 'sch-activities')}</td>
            <td>
                <button type="button"
                        class="btn-remove"
                        onclick="data.scheduleItems.splice(${index}, 1); renderSchedule(); updateSectionProgress();">
                    <i class="bi bi-trash"></i>
                </button>
            </td>
        </tr>
    `).join('');
}

function addAssessment(item = {
    category: '', partNumber: '', weight: null, duration: '', cloCodes: '',
    questionType: '', numberOfQuestions: '', knowledgeScope: '',
    assessmentMethod: '', note: ''
}) {
    data.assessments.push(item);
    renderAssessments();
    updateSectionProgress();
}

function renderAssessments() {
    assessmentBody.innerHTML = data.assessments.map((item, index) => `
        <tr>
            <td>${rowText(item.category, 'ass-category')}</td>
            <td>${rowInput(item.partNumber, 'ass-part')}</td>
            <td>${rowInput(item.weight, 'ass-weight', 'number')}</td>
            <td>${rowText(item.duration, 'ass-duration')}</td>
            <td>${rowText(item.cloCodes, 'ass-clos')}</td>
            <td>${rowText(item.questionType, 'ass-question')}</td>
            <td>${rowInput(item.numberOfQuestions, 'ass-number')}</td>
            <td>${rowText(item.knowledgeScope, 'ass-scope')}</td>
            <td>${rowText(item.assessmentMethod, 'ass-method')}</td>
            <td>${rowText(item.note, 'ass-note')}</td>
            <td>
                <button type="button"
                        class="btn-remove"
                        onclick="data.assessments.splice(${index}, 1); renderAssessments(); updateSectionProgress();">
                    <i class="bi bi-trash"></i>
                </button>
            </td>
        </tr>
    `).join('');
    document.querySelectorAll('.ass-weight').forEach(element => {
        element.addEventListener('input', () => {
            updateWeight();
            updateSectionProgress();
        });
    });
    updateWeight();
}

function renderCloCoMapping() {
    if (!coMappingContainer) return;

    if (data.courseObjectives.length === 0) {
        coMappingContainer.innerHTML = `
            <div class="empty-hint">Add at least one Course Objective before mapping CLOs.</div>
        `;
        return;
    }
    if (data.clos.length === 0) {
        coMappingContainer.innerHTML = `
            <div class="empty-hint">Add at least one CLO before building the CLO-CO mapping.</div>
        `;
        return;
    }

    const headers = data.courseObjectives.map(co => `
        <th title="${esc(co.description || '')}">
            <div>${esc(co.code || 'CO')}</div>
            <small>${esc(co.description || '')}</small>
        </th>
    `).join('');

    const rows = data.clos.map(clo => {
        const selected = (data.cloCoMappings[clo.code] || []).map(String);
        const cells = data.courseObjectives.map(co => `
            <td>
                <input type="checkbox"
                       class="co-mapping-check"
                       data-clo="${esc(clo.code)}"
                       data-co="${esc(co.code)}"
                       aria-label="Map ${esc(clo.code)} to ${esc(co.code)}"
                       ${selected.includes(String(co.code)) ? 'checked' : ''}>
            </td>
        `).join('');

        return `
            <tr>
                <td>
                    <strong>${esc(clo.code)}</strong>
                    <div class="clo-mapping-description">${esc(clo.description)}</div>
                </td>
                ${cells}
            </tr>
        `;
    }).join('');

    coMappingContainer.innerHTML = `
        <div class="editor-table-wrap">
            <table class="mapping-table co-mapping-table">
                <thead><tr><th>CLO</th>${headers}</tr></thead>
                <tbody>${rows}</tbody>
            </table>
        </div>
    `;
}

function renderMapping() {
    const groups = data.curriculumPloGroups || [];

    if (groups.length === 0) {
        mappingContainer.innerHTML = `
            <div class="empty-hint">
                This course is not included in any curriculum provided by Academic Office.
            </div>
        `;
        return;
    }
    if (data.clos.length === 0) {
        mappingContainer.innerHTML = `
            <div class="empty-hint">Add at least one CLO to build the PLO mapping tables.</div>
        `;
        return;
    }

    mappingContainer.innerHTML = groups.map(group => {
        const plos = group.plos || [];
        const curriculumTitle = [group.curriculumCode, group.curriculumName]
            .filter(Boolean).join(' - ');
        const semesterText = group.semester == null
            ? ''
            : `<span class="curriculum-semester">Semester ${esc(group.semester)}</span>`;

        if (plos.length === 0) {
            return `
                <section class="curriculum-mapping-card">
                    <div class="curriculum-mapping-head">
                        <div>
                            <div class="curriculum-code">${esc(curriculumTitle)}</div>
                            <div class="curriculum-note">Course-specific PLO scope from Academic Office</div>
                        </div>
                        ${semesterText}
                    </div>
                    <div class="curriculum-mapping-body">
                        <div class="empty-hint mapping-warning">
                            Academic Office has not assigned any PLO to this course in this curriculum.
                        </div>
                    </div>
                </section>
            `;
        }

        const headers = plos.map(plo => `
            <th title="${esc(plo.description || plo.name || '')}">
                <div>${esc(plo.code)}</div>
            </th>
        `).join('');

        const rows = data.clos.map(clo => {
            const selectedPloIds = (data.cloPloMappings[clo.code] || []).map(Number);
            const cells = plos.map(plo => `
                <td>
                    <input type="checkbox"
                           class="mapping-check"
                           data-clo="${esc(clo.code)}"
                           data-curriculum="${esc(group.curriculumId)}"
                           data-plo="${esc(plo.ploId)}"
                           aria-label="Map ${esc(clo.code)} to ${esc(plo.code)} in ${esc(group.curriculumCode)}"
                           ${selectedPloIds.includes(Number(plo.ploId)) ? 'checked' : ''}>
                </td>
            `).join('');

            return `
                <tr>
                    <td>
                        <strong>${esc(clo.code)}</strong>
                        <div class="clo-mapping-description">${esc(clo.description)}</div>
                    </td>
                    ${cells}
                </tr>
            `;
        }).join('');

        return `
            <section class="curriculum-mapping-card">
                <div class="curriculum-mapping-head">
                    <div>
                        <div class="curriculum-code">${esc(curriculumTitle)}</div>
                        <div class="curriculum-note">
                            Every CLO needs at least one PLO in this curriculum, and every listed PLO must be covered.
                        </div>
                    </div>
                    ${semesterText}
                </div>
                <div class="curriculum-mapping-body">
                    <div class="editor-table-wrap">
                        <table class="mapping-table curriculum-mapping-table">
                            <thead><tr><th>CLO</th>${headers}</tr></thead>
                            <tbody>${rows}</tbody>
                        </table>
                    </div>
                </div>
            </section>
        `;
    }).join('');
}

function collect() {
    const general = data.generalInformation;
    ['courseCode', 'courseName', 'degreeLevel', 'timeAllocation',
        'prerequisiteText', 'courseDescription'].forEach(key => {
        general[key] = document.getElementById(key).value.trim();
    });
    general.credits = document.getElementById('credits').value
        ? Number(document.getElementById('credits').value) : null;

    data.courseObjectives = [...coBody.rows].map(row => ({
        code: row.querySelector('.co-code').value.trim(),
        description: row.querySelector('.co-description').value.trim()
    })).filter(item => item.code || item.description);

    data.clos = [...cloBody.rows].map(row => ({
        code: row.querySelector('.clo-code').value.trim(),
        description: row.querySelector('.clo-description').value.trim(),
        bloomLevel: row.querySelector('.clo-bloom').value || null
    })).filter(item => item.code || item.description);

    data.studentTasks = [...taskBody.rows].map(row => ({
        content: row.querySelector('.task-content').value.trim()
    })).filter(item => item.content);

    data.learningResources = [...resourceBody.rows].map(row => ({
        category: row.querySelector('.res-category').value,
        title: row.querySelector('.res-title').value.trim(),
        author: row.querySelector('.res-author').value.trim(),
        url: row.querySelector('.res-url').value.trim(),
        description: row.querySelector('.res-description').value.trim()
    })).filter(item => item.title || item.description);

    data.scheduleItems = [...scheduleBody.rows].map(row => ({
        sessionNumber: row.querySelector('.sch-session').value
            ? Number(row.querySelector('.sch-session').value) : null,
        category: row.querySelector('.sch-category').value.trim(),
        topic: row.querySelector('.sch-topic').value.trim(),
        cloCodes: row.querySelector('.sch-clos').value.trim(),
        ituLevel: row.querySelector('.sch-itu').value.trim(),
        materials: row.querySelector('.sch-materials').value.trim(),
        activities: row.querySelector('.sch-activities').value.trim()
    })).filter(item => item.sessionNumber !== null);

    data.assessments = [...assessmentBody.rows].map(row => ({
        category: row.querySelector('.ass-category').value.trim(),
        partNumber: row.querySelector('.ass-part').value.trim(),
        weight: row.querySelector('.ass-weight').value
            ? Number(row.querySelector('.ass-weight').value) : null,
        duration: row.querySelector('.ass-duration').value.trim(),
        cloCodes: row.querySelector('.ass-clos').value.trim(),
        questionType: row.querySelector('.ass-question').value.trim(),
        numberOfQuestions: row.querySelector('.ass-number').value.trim(),
        knowledgeScope: row.querySelector('.ass-scope').value.trim(),
        assessmentMethod: row.querySelector('.ass-method').value.trim(),
        note: row.querySelector('.ass-note').value.trim()
    })).filter(item => item.category);

    data.cloCoMappings = {};
    document.querySelectorAll('.co-mapping-check:checked').forEach(checkbox => {
        const cloCode = checkbox.dataset.clo;
        const coCode = checkbox.dataset.co;
        if (!data.cloCoMappings[cloCode]) data.cloCoMappings[cloCode] = [];
        if (!data.cloCoMappings[cloCode].includes(coCode)) {
            data.cloCoMappings[cloCode].push(coCode);
        }
    });

    data.cloPloMappings = {};
    document.querySelectorAll('.mapping-check:checked').forEach(checkbox => {
        const cloCode = checkbox.dataset.clo;
        const ploId = Number(checkbox.dataset.plo);
        if (!data.cloPloMappings[cloCode]) data.cloPloMappings[cloCode] = [];
        if (!data.cloPloMappings[cloCode].includes(ploId)) {
            data.cloPloMappings[cloCode].push(ploId);
        }
    });

    return data;
}

function validateForSubmitClient() {
    const errors = [];
    const coCodes = [];
    const cloCodes = [];

    if (!data.courseObjectives.length) {
        errors.push('Add at least one Course Objective (CO).');
    }
    data.courseObjectives.forEach((co, index) => {
        const code = normalizeCode(co.code, 'CO');
        if (!code || !String(co.description || '').trim()) {
            errors.push(`CO row ${index + 1} needs a valid code and description.`);
        } else if (coCodes.includes(code)) {
            errors.push(`Duplicate CO code: ${code}.`);
        } else {
            coCodes.push(code);
        }
    });

    if (!data.clos.length) {
        errors.push('Add at least one Course Learning Outcome (CLO).');
    }
    data.clos.forEach((clo, index) => {
        const code = normalizeCode(clo.code, 'CLO');
        if (!code || !String(clo.description || '').trim()) {
            errors.push(`CLO row ${index + 1} needs a valid code and description.`);
        } else if (cloCodes.includes(code)) {
            errors.push(`Duplicate CLO code: ${code}.`);
        } else {
            cloCodes.push(code);
        }
    });

    const coveredCos = new Set();
    cloCodes.forEach(cloCode => {
        const mappedCos = (data.cloCoMappings[cloCode] || [])
            .map(code => normalizeCode(code, 'CO')).filter(Boolean);
        if (!mappedCos.length) {
            errors.push(`${cloCode} must map to at least one CO.`);
        }
        mappedCos.forEach(code => coveredCos.add(code));
    });
    coCodes.forEach(coCode => {
        if (!coveredCos.has(coCode)) {
            errors.push(`${coCode} must be covered by at least one CLO.`);
        }
    });

    const selectedPloIds = new Set();
    (data.curriculumPloGroups || []).forEach(group => {
        const plos = group.plos || [];
        if (!plos.length) return;
        const allowedIds = new Set(plos.map(plo => Number(plo.ploId)));

        cloCodes.forEach(cloCode => {
            const mappedIds = (data.cloPloMappings[cloCode] || []).map(Number);
            if (!mappedIds.some(id => allowedIds.has(id))) {
                errors.push(`${cloCode} must map to at least one PLO in ${group.curriculumCode || 'each curriculum'}.`);
            }
            mappedIds.forEach(id => {
                if (allowedIds.has(id)) selectedPloIds.add(id);
            });
        });

        plos.forEach(plo => {
            if (!selectedPloIds.has(Number(plo.ploId))) {
                errors.push(`${group.curriculumCode || 'Curriculum'} / ${plo.code} must be covered by at least one CLO.`);
            }
        });
    });

    if (!(data.curriculumPloGroups || []).some(group => (group.plos || []).length)) {
        errors.push('Academic Office has not assigned any PLO scope to this course.');
    }

    if (data.assessments.length) {
        const total = data.assessments.reduce((sum, item) => sum + (Number(item.weight) || 0), 0);
        if (Math.abs(total - 1) > 0.001) {
            errors.push(`Assessment weights must total 100%. Current total: ${(total * 100).toFixed(1)}%.`);
        }
    }

    return [...new Set(errors)];
}

function showValidationSummary(errors) {
    if (!validationSummary) return;
    if (!errors.length) {
        validationSummary.className = 'validation-summary validation-ok';
        validationSummary.innerHTML = '<strong><i class="bi bi-check-circle-fill"></i> Ready to submit.</strong> All required mappings are complete.';
        return;
    }
    validationSummary.className = 'validation-summary validation-error';
    validationSummary.innerHTML = `
        <strong><i class="bi bi-exclamation-triangle-fill"></i> Complete these items before submitting:</strong>
        <ul>${errors.map(error => `<li>${esc(error)}</li>`).join('')}</ul>
    `;
}

function setStepState(step, label, className) {
    const anchor = document.querySelector(`.section-nav a[data-step="${step}"]`);
    if (!anchor) return;
    const state = anchor.querySelector('.step-state');
    if (state) state.textContent = label;
    anchor.classList.remove('step-complete', 'step-incomplete', 'step-reference', 'step-optional');
    anchor.classList.add(className);
}

function updateSectionProgress() {
    try { collect(); } catch (ignored) { /* During initial render some rows may not exist yet. */ }

    const validCos = data.courseObjectives.length > 0
        && data.courseObjectives.every(co => normalizeCode(co.code, 'CO') && String(co.description || '').trim());
    const validClos = data.clos.length > 0
        && data.clos.every(clo => normalizeCode(clo.code, 'CLO') && String(clo.description || '').trim());

    const coErrors = [];
    if (validCos && validClos) {
        const covered = new Set();
        data.clos.forEach(clo => {
            const code = normalizeCode(clo.code, 'CLO');
            const mappings = data.cloCoMappings[code] || [];
            if (!mappings.length) coErrors.push(code);
            mappings.forEach(co => covered.add(normalizeCode(co, 'CO')));
        });
        data.courseObjectives.forEach(co => {
            if (!covered.has(normalizeCode(co.code, 'CO'))) coErrors.push(co.code);
        });
    }

    setStepState('general', 'Reference', 'step-reference');
    setStepState('objectives', validCos ? 'Complete' : 'Required', validCos ? 'step-complete' : 'step-incomplete');
    setStepState('clos', validClos ? 'Complete' : 'Required', validClos ? 'step-complete' : 'step-incomplete');
    setStepState('co-mapping', validCos && validClos && !coErrors.length ? 'Complete' : 'Required', validCos && validClos && !coErrors.length ? 'step-complete' : 'step-incomplete');
    setStepState('tasks', data.studentTasks.length ? 'Added' : 'Optional', data.studentTasks.length ? 'step-complete' : 'step-optional');
    setStepState('resources', data.learningResources.length ? 'Added' : 'Optional', data.learningResources.length ? 'step-complete' : 'step-optional');
    setStepState('schedule', data.scheduleItems.length ? 'Added' : 'Optional', data.scheduleItems.length ? 'step-complete' : 'step-optional');
    setStepState('assessments', data.assessments.length ? 'Added' : 'Optional', data.assessments.length ? 'step-complete' : 'step-optional');

    const ploErrors = validateForSubmitClient().filter(error => error.includes('PLO'));
    setStepState('mapping', ploErrors.length ? 'Required' : 'Complete', ploErrors.length ? 'step-incomplete' : 'step-complete');
}

function updateWeight() {
    const total = [...document.querySelectorAll('.ass-weight')]
        .reduce((sum, element) => sum + (Number(element.value) || 0), 0);
    weightTotal.textContent = (total * 100).toFixed(1) + '%';
    weightTotal.style.color = Math.abs(total - 1) < 0.001 ? '#15803d' : '#b45309';
}

function submitEditor(mode) {
    collect();

    if (mode === 'submit') {
        const errors = validateForSubmitClient();
        showValidationSummary(errors);
        if (errors.length) {
            validationSummary.scrollIntoView({behavior: 'smooth', block: 'center'});
            return;
        }
        if (!confirm(
            'Submit this syllabus for review? Each CLO must map to at least one CO and at least one PLO in every curriculum. Every CO and every assigned PLO must also be covered.'
        )) {
            return;
        }
    }

    editorJson.value = JSON.stringify(data);
    editorForm.action = contextPath + '/designer/editor/' + mode;
    editorForm.submit();
}

bindGeneral();
renderCos();
renderClos();
renderTasks();
renderResources();
renderSchedule();
renderAssessments();
renderCloCoMapping();
renderMapping();
updateSectionProgress();

document.getElementById('editorForm').addEventListener('input', updateSectionProgress);
document.getElementById('editorForm').addEventListener('change', updateSectionProgress);
