(function () {
    'use strict';

    function normalizedValue(element) {
        return element ? element.value.trim().toLowerCase() : '';
    }

    function matchesFilter(element, search, semester, group, category) {
        var searchableText = element.dataset.search || '';
        return (!search || searchableText.indexOf(search) !== -1)
            && (semester === 'ALL' || element.dataset.semester === semester)
            && (group === 'ALL' || element.dataset.group === group)
            && (category === 'ALL' || element.dataset.category === category);
    }

    function initializeLanguageSwitch() {
        var root = document.querySelector('[data-curriculum-detail]');
        if (!root) return;

        var buttons = Array.from(root.querySelectorAll('[data-language-button]'));
        var panels = Array.from(root.querySelectorAll('[data-language-panel]'));
        buttons.forEach(function (button) {
            button.addEventListener('click', function () {
                var language = button.dataset.languageButton;
                buttons.forEach(function (item) {
                    var isActive = item === button;
                    item.classList.toggle('is-active', isActive);
                    item.setAttribute('aria-pressed', String(isActive));
                });
                panels.forEach(function (panel) {
                    panel.hidden = panel.dataset.languagePanel !== language;
                });
            });
        });
    }

    function initializeSubjectRoadmap() {
        var root = document.querySelector('[data-curriculum-detail]');
        if (!root) return;

        var searchInput = root.querySelector('[data-subject-search]');
        var categorySelect = root.querySelector('[data-subject-category]');
        var summary = root.querySelector('[data-subject-filter-summary]');
        var subjectRows = Array.from(root.querySelectorAll('[data-subject-row]'));
        var semesterBlocks = Array.from(root.querySelectorAll('[data-semester-block]'));

        function applyRoadmapFilters() {
            var search = normalizedValue(searchInput);
            var category = categorySelect ? categorySelect.value : 'ALL';
            var visibleCount = 0;

            subjectRows.forEach(function (row) {
                var visible = matchesFilter(row, search, 'ALL', 'ALL', category);
                row.hidden = !visible;
                if (visible) visibleCount += 1;
            });

            semesterBlocks.forEach(function (block) {
                var hasVisibleRows = Array.from(block.querySelectorAll('[data-subject-row]'))
                    .some(function (row) { return !row.hidden; });
                var emptyMessage = block.querySelector('[data-semester-empty]');
                var table = block.querySelector('.curriculum-subject-table-wrap');
                if (emptyMessage) emptyMessage.hidden = hasVisibleRows;
                if (table) table.hidden = !hasVisibleRows;
            });

            if (summary) {
                summary.textContent = visibleCount === subjectRows.length
                    ? 'Showing all ' + subjectRows.length + ' subjects.'
                    : 'Showing ' + visibleCount + ' of ' + subjectRows.length + ' subjects.';
            }
        }

        if (searchInput) searchInput.addEventListener('input', applyRoadmapFilters);
        if (categorySelect) categorySelect.addEventListener('change', applyRoadmapFilters);
    }

    function initializeOutcomeTabs() {
        var root = document.querySelector('[data-curriculum-outcomes]');
        if (!root) return;

        var tabs = Array.from(root.querySelectorAll('[data-outcome-tab]'));
        var panels = Array.from(root.querySelectorAll('[data-outcome-panel]'));
        tabs.forEach(function (tab, tabIndex) {
            tab.addEventListener('click', function () {
                var target = tab.dataset.outcomeTab;
                tabs.forEach(function (item) {
                    var isActive = item === tab;
                    item.classList.toggle('is-active', isActive);
                    item.setAttribute('aria-selected', String(isActive));
                    item.tabIndex = isActive ? 0 : -1;
                });
                panels.forEach(function (panel) {
                    panel.hidden = panel.dataset.outcomePanel !== target;
                });
            });
            tab.addEventListener('keydown', function (event) {
                if (event.key !== 'ArrowLeft' && event.key !== 'ArrowRight') return;
                event.preventDefault();
                var direction = event.key === 'ArrowRight' ? 1 : -1;
                var nextIndex = (tabIndex + direction + tabs.length) % tabs.length;
                tabs[nextIndex].focus();
                tabs[nextIndex].click();
            });
        });
        tabs.forEach(function (tab, index) { tab.tabIndex = index === 0 ? 0 : -1; });
    }

    function initializeSubjectMapping() {
        var root = document.querySelector('[data-subject-mapping]');
        if (!root) return;

        var searchInput = root.querySelector('[data-mapping-search]');
        var semesterSelect = root.querySelector('[data-mapping-semester]');
        var groupSelect = root.querySelector('[data-mapping-group]');
        var categorySelect = root.querySelector('[data-mapping-category]');
        var count = root.querySelector('[data-mapping-count]');
        var matrixRows = Array.from(root.querySelectorAll('[data-mapping-row]'));
        var listRows = Array.from(root.querySelectorAll('[data-mapping-list-row]'));
        var groupHeadings = Array.from(root.querySelectorAll('[data-mapping-group-heading]'));
        var listGroups = Array.from(root.querySelectorAll('[data-mapping-list-group]'));
        var emptyState = root.querySelector('[data-mapping-empty]');
        var viewButtons = Array.from(root.querySelectorAll('[data-mapping-view]'));
        var viewPanels = Array.from(root.querySelectorAll('[data-mapping-panel]'));

        function applyMappingFilters() {
            var search = normalizedValue(searchInput);
            var semester = semesterSelect ? semesterSelect.value : 'ALL';
            var group = groupSelect ? groupSelect.value : 'ALL';
            var category = categorySelect ? categorySelect.value : 'ALL';
            var visibleCount = 0;

            matrixRows.forEach(function (row) {
                var visible = matchesFilter(row, search, semester, group, category);
                row.hidden = !visible;
                if (visible) visibleCount += 1;
            });
            listRows.forEach(function (row) {
                row.hidden = !matchesFilter(row, search, semester, group, category);
            });

            groupHeadings.forEach(function (heading) {
                var groupCode = heading.dataset.mappingGroupHeading;
                heading.hidden = !matrixRows.some(function (row) {
                    return row.dataset.group === groupCode && !row.hidden;
                });
            });
            listGroups.forEach(function (section) {
                section.hidden = !Array.from(section.querySelectorAll('[data-mapping-list-row]'))
                    .some(function (row) { return !row.hidden; });
            });

            if (count) count.textContent = String(visibleCount);
            if (emptyState) emptyState.hidden = visibleCount !== 0;
        }

        [searchInput, semesterSelect, groupSelect, categorySelect].forEach(function (control) {
            if (!control) return;
            control.addEventListener(control.tagName === 'INPUT' ? 'input' : 'change', applyMappingFilters);
        });

        viewButtons.forEach(function (button) {
            button.addEventListener('click', function () {
                var view = button.dataset.mappingView;
                viewButtons.forEach(function (item) {
                    var isActive = item === button;
                    item.classList.toggle('is-active', isActive);
                    item.setAttribute('aria-pressed', String(isActive));
                });
                viewPanels.forEach(function (panel) {
                    panel.hidden = panel.dataset.mappingPanel !== view;
                });
            });
        });
    }

    document.addEventListener('DOMContentLoaded', function () {
        initializeLanguageSwitch();
        initializeSubjectRoadmap();
        initializeOutcomeTabs();
        initializeSubjectMapping();
    });
})();
