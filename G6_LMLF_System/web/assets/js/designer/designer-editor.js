'use strict';

const contextPath = document.body.dataset.contextPath || '';
const initialJsonElement = document.getElementById('initialJson');
const editorForm = document.getElementById('editorForm');
const editorJson = document.getElementById('editorJson');
const mappingContainer = document.getElementById('mappingContainer');
const cloBody = document.getElementById('cloBody');
const taskBody = document.getElementById('taskBody');
const resourceBody = document.getElementById('resourceBody');
const scheduleBody = document.getElementById('scheduleBody');
const assessmentBody = document.getElementById('assessmentBody');
const weightTotal = document.getElementById('weightTotal');

let data = JSON.parse(initialJsonElement.value || '{}');

data.generalInformation = data.generalInformation || {};
data.clos = data.clos || [];
data.studentTasks = data.studentTasks || [];
data.learningResources = data.learningResources || [];
data.scheduleItems = data.scheduleItems || [];
data.assessments = data.assessments || [];
data.curriculumPloGroups = data.curriculumPloGroups || [];
data.plos = data.plos || [];
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
        document.getElementById(key).value = general[key] ?? '';
    });
}

function rowInput(value, className, type = 'text') {
    return `<input type="${type}" class="${className}" value="${esc(value)}">`;
}

function rowText(value, className) {
    return `<textarea class="${className}">${esc(value)}</textarea>`;
}

function captureCurrentMappingSelections() {
    const mappings = {};

    document.querySelectorAll('.mapping-check:checked').forEach(checkbox => {
        const cloCode = checkbox.dataset.clo;
        const ploId = Number(checkbox.dataset.plo);

        if (!cloCode || !Number.isFinite(ploId)) {
            return;
        }

        if (!mappings[cloCode]) {
            mappings[cloCode] = [];
        }

        if (!mappings[cloCode].includes(ploId)) {
            mappings[cloCode].push(ploId);
        }
    });

    if (document.querySelector('.mapping-check')) {
        data.cloPloMappings = mappings;
    }
}

function handleCloCodeChange(index, newValue) {
    captureCurrentMappingSelections();

    const clo = data.clos[index];
    if (!clo) {
        return;
    }

    const oldCode = clo.code || '';
    const trimmedCode = String(newValue || '').trim();

    if (oldCode !== trimmedCode && data.cloPloMappings[oldCode]) {
        data.cloPloMappings[trimmedCode] = data.cloPloMappings[oldCode];
        delete data.cloPloMappings[oldCode];
    }

    clo.code = trimmedCode;
    renderMapping();
}

function addClo(item = {
    code: 'CLO' + (data.clos.length + 1),
    description: '',
    bloomLevel: ''
}) {
    captureCurrentMappingSelections();
    data.clos.push(item);
    renderClos();
    renderMapping();
}

function removeClo(index) {
    captureCurrentMappingSelections();

    const removed = data.clos[index];
    if (removed && removed.code) {
        delete data.cloPloMappings[removed.code];
    }

    data.clos.splice(index, 1);
    renderClos();
    renderMapping();
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
                        'Remember',
                        'Understand',
                        'Apply',
                        'Analyze',
                        'Evaluate',
                        'Create'
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
}

function renderTasks() {
    taskBody.innerHTML = data.studentTasks.map((item, index) => `
        <tr>
            <td>${index + 1}</td>
            <td>${rowText(item.content, 'task-content')}</td>
            <td>
                <button type="button"
                        class="btn-remove"
                        onclick="data.studentTasks.splice(${index}, 1); renderTasks();">
                    <i class="bi bi-trash"></i>
                </button>
            </td>
        </tr>
    `).join('');
}

function addResource(item = {
    category: 'OTHER',
    title: '',
    author: '',
    url: '',
    description: ''
}) {
    data.learningResources.push(item);
    renderResources();
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
                        onclick="data.learningResources.splice(${index}, 1); renderResources();">
                    <i class="bi bi-trash"></i>
                </button>
            </td>
        </tr>
    `).join('');
}

function addSchedule(item = {
    sessionNumber: data.scheduleItems.length + 1,
    category: '',
    topic: '',
    cloCodes: '',
    ituLevel: '',
    materials: '',
    activities: ''
}) {
    data.scheduleItems.push(item);
    renderSchedule();
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
                        onclick="data.scheduleItems.splice(${index}, 1); renderSchedule();">
                    <i class="bi bi-trash"></i>
                </button>
            </td>
        </tr>
    `).join('');
}

function addAssessment(item = {
    category: '',
    partNumber: '',
    weight: null,
    duration: '',
    cloCodes: '',
    questionType: '',
    numberOfQuestions: '',
    knowledgeScope: '',
    assessmentMethod: '',
    note: ''
}) {
    data.assessments.push(item);
    renderAssessments();
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
                        onclick="data.assessments.splice(${index}, 1); renderAssessments();">
                    <i class="bi bi-trash"></i>
                </button>
            </td>
        </tr>
    `).join('');

    document.querySelectorAll('.ass-weight').forEach(element => {
        element.addEventListener('input', updateWeight);
    });

    updateWeight();
}

function renderMapping() {
    const groups = data.curriculumPloGroups || [];

    if (groups.length === 0) {
        mappingContainer.innerHTML = `
            <div class="empty-hint">
                This course is not included in any curriculum provided by Academic Office.
                Academic Office must add this course to at least one curriculum first.
            </div>
        `;
        return;
    }

    if (data.clos.length === 0) {
        mappingContainer.innerHTML = `
            <div class="empty-hint">
                Add at least one CLO to build the curriculum-specific mapping tables.
            </div>
        `;
        return;
    }

    mappingContainer.innerHTML = groups.map(group => {
        const plos = group.plos || [];
        const curriculumTitle = [
            group.curriculumCode,
            group.curriculumName
        ].filter(Boolean).join(' - ');

        const semesterText = group.semester == null
            ? ''
            : `<span class="curriculum-semester">Semester ${esc(group.semester)}</span>`;

        if (plos.length === 0) {
            return `
                <section class="curriculum-mapping-card">
                    <div class="curriculum-mapping-head">
                        <div>
                            <div class="curriculum-code">${esc(curriculumTitle)}</div>
                            <div class="curriculum-note">
                                Course-specific PLO scope from Academic Office
                            </div>
                        </div>
                        ${semesterText}
                    </div>
                    <div class="curriculum-mapping-body">
                        <div class="empty-hint mapping-warning">
                            Academic Office has not assigned any PLO to this course
                            in curriculum ${esc(group.curriculumCode)}.
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
            const selectedPloIds = (data.cloPloMappings[clo.code] || [])
                .map(Number);

            const cells = plos.map(plo => {
                const checked = selectedPloIds.includes(Number(plo.ploId));

                return `
                    <td>
                        <input type="checkbox"
                               class="mapping-check"
                               data-clo="${esc(clo.code)}"
                               data-curriculum="${esc(group.curriculumId)}"
                               data-plo="${esc(plo.ploId)}"
                               aria-label="Map ${esc(clo.code)} to ${esc(plo.code)} in ${esc(group.curriculumCode)}"
                               ${checked ? 'checked' : ''}>
                    </td>
                `;
            }).join('');

            return `
                <tr>
                    <td>
                        <strong>${esc(clo.code)}</strong>
                        <div class="clo-mapping-description">
                            ${esc(clo.description)}
                        </div>
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
                            Only the PLOs assigned to this course by Academic Office are shown.
                        </div>
                    </div>
                    ${semesterText}
                </div>
                <div class="curriculum-mapping-body">
                    <div class="editor-table-wrap">
                        <table class="mapping-table curriculum-mapping-table">
                            <thead>
                                <tr>
                                    <th>CLO</th>
                                    ${headers}
                                </tr>
                            </thead>
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

    [
        'courseCode',
        'courseName',
        'degreeLevel',
        'timeAllocation',
        'prerequisiteText',
        'courseDescription'
    ].forEach(key => {
        general[key] = document.getElementById(key).value.trim();
    });

    general.credits = document.getElementById('credits').value
        ? Number(document.getElementById('credits').value)
        : null;

    data.clos = [...cloBody.rows].map(row => ({
        code: row.querySelector('.clo-code').value.trim(),
        description: row.querySelector('.clo-description').value.trim(),
        bloomLevel: row.querySelector('.clo-bloom').value || null
    }));

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
            ? Number(row.querySelector('.sch-session').value)
            : null,
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
            ? Number(row.querySelector('.ass-weight').value)
            : null,
        duration: row.querySelector('.ass-duration').value.trim(),
        cloCodes: row.querySelector('.ass-clos').value.trim(),
        questionType: row.querySelector('.ass-question').value.trim(),
        numberOfQuestions: row.querySelector('.ass-number').value.trim(),
        knowledgeScope: row.querySelector('.ass-scope').value.trim(),
        assessmentMethod: row.querySelector('.ass-method').value.trim(),
        note: row.querySelector('.ass-note').value.trim()
    })).filter(item => item.category);

    data.cloPloMappings = {};

    document.querySelectorAll('.mapping-check:checked').forEach(checkbox => {
        const cloCode = checkbox.dataset.clo;
        const ploId = Number(checkbox.dataset.plo);

        if (!data.cloPloMappings[cloCode]) {
            data.cloPloMappings[cloCode] = [];
        }

        if (!data.cloPloMappings[cloCode].includes(ploId)) {
            data.cloPloMappings[cloCode].push(ploId);
        }
    });

    return data;
}

function updateWeight() {
    const total = [...document.querySelectorAll('.ass-weight')]
        .reduce((sum, element) => sum + (Number(element.value) || 0), 0);

    weightTotal.textContent = (total * 100).toFixed(1) + '%';
    weightTotal.style.color = Math.abs(total - 1) < 0.001
        ? '#15803d'
        : '#b45309';
}

function submitEditor(mode) {
    collect();

    if (mode === 'submit' && !confirm(
        'Submit this syllabus for review? Every Academic Office PLO assigned '
        + 'to the course must be covered by at least one CLO.'
    )) {
        return;
    }

    editorJson.value = JSON.stringify(data);
    editorForm.action = contextPath + '/designer/editor/' + mode;
    editorForm.submit();
}

bindGeneral();
renderClos();
renderTasks();
renderResources();
renderSchedule();
renderAssessments();
renderMapping();
