(function () {
    'use strict';

    function initDependencyGraphs() {
        var graphs = document.querySelectorAll('[data-dependency-graph]');
        if (!graphs.length) {
            return;
        }

        var redraw = debounce(function () {
            graphs.forEach(drawDependencyGraph);
        }, 120);

        graphs.forEach(drawDependencyGraph);
        window.addEventListener('resize', redraw);

        if (document.fonts && document.fonts.ready) {
            document.fonts.ready.then(function () {
                graphs.forEach(drawDependencyGraph);
            });
        }
    }

    function drawDependencyGraph(canvas) {
        var svg = canvas.querySelector('.dependency-lines');
        if (!svg) {
            return;
        }

        if (window.matchMedia('(max-width: 768px)').matches) {
            svg.innerHTML = '';
            return;
        }

        var nodeElements = canvas.querySelectorAll('[data-subject-node]');
        var edgeElements = canvas.querySelectorAll('[data-graph-edge]');
        if (!nodeElements.length || !edgeElements.length) {
            svg.innerHTML = '';
            return;
        }

        var nodeMap = {};
        nodeElements.forEach(function (node) {
            nodeMap[node.getAttribute('data-node-code')] = node;
        });

        var width = Math.max(canvas.scrollWidth, canvas.clientWidth);
        var height = Math.max(canvas.scrollHeight, canvas.clientHeight);
        svg.setAttribute('width', width);
        svg.setAttribute('height', height);
        svg.setAttribute('viewBox', '0 0 ' + width + ' ' + height);

        var markerId = 'dependencyArrow-' + (canvas.id || 'graph');
        svg.innerHTML =
            '<defs>' +
                '<marker id="' + markerId + '" markerWidth="8" markerHeight="8" ' +
                    'refX="7" refY="4" orient="auto" markerUnits="strokeWidth">' +
                    '<path d="M0,0 L8,4 L0,8 z" fill="#cbd5e1"></path>' +
                '</marker>' +
            '</defs>';

        var canvasRect = canvas.getBoundingClientRect();
        edgeElements.forEach(function (edge) {
            var fromNode = nodeMap[edge.getAttribute('data-from')];
            var toNode = nodeMap[edge.getAttribute('data-to')];
            if (!fromNode || !toNode) {
                return;
            }

            var fromRect = fromNode.getBoundingClientRect();
            var toRect = toNode.getBoundingClientRect();
            var startX = fromRect.right - canvasRect.left;
            var startY = fromRect.top - canvasRect.top + (fromRect.height / 2);
            var endX = toRect.left - canvasRect.left;
            var endY = toRect.top - canvasRect.top + (toRect.height / 2);

            var path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
            if (endX <= startX) {
                startX = fromRect.left - canvasRect.left + (fromRect.width / 2);
                startY = fromRect.bottom - canvasRect.top;
                endX = toRect.left - canvasRect.left + (toRect.width / 2);
                endY = toRect.top - canvasRect.top;
                var verticalMid = (startY + endY) / 2;
                path.setAttribute(
                    'd',
                    'M ' + startX + ' ' + startY +
                    ' C ' + startX + ' ' + verticalMid +
                    ', ' + endX + ' ' + verticalMid +
                    ', ' + endX + ' ' + endY
                );
            } else {
                var horizontalOffset = Math.max(34, (endX - startX) * 0.45);
                path.setAttribute(
                    'd',
                    'M ' + startX + ' ' + startY +
                    ' C ' + (startX + horizontalOffset) + ' ' + startY +
                    ', ' + (endX - horizontalOffset) + ' ' + endY +
                    ', ' + endX + ' ' + endY
                );
            }
            path.setAttribute('fill', 'none');
            path.setAttribute('stroke', '#cbd5e1');
            path.setAttribute('stroke-width', '1.7');
            path.setAttribute('marker-end', 'url(#' + markerId + ')');
            svg.appendChild(path);
        });
    }

    function initMaterialBrowser() {
        var form = document.querySelector('#materialsDownloadForm');
        if (!form) {
            return;
        }

        var materialCheckboxes = Array.from(form.querySelectorAll('.material-check'));
        var courseToggles = Array.from(form.querySelectorAll('.course-toggle'));
        var selectedCount = document.querySelector('#selectedMaterialCount');
        var selectedCourseCount = document.querySelector('#selectedCourseCount');
        var selectedSize = document.querySelector('#selectedMaterialSize');
        var downloadSelected = document.querySelector('#downloadSelectedButton');
        var downloadAll = document.querySelector('#downloadAllButton');
        var validationMessage = document.querySelector('#packageValidationMessage');

        if (!selectedCount || !downloadSelected) {
            return;
        }

        function updateSelectionSummary() {
            var selected = materialCheckboxes.filter(function (cb) {
                return cb.checked && !cb.disabled;
            });
            var courseCodes = new Set();
            var size = 0;

            selected.forEach(function (cb) {
                courseCodes.add(cb.getAttribute('data-course'));
                size += Number(cb.getAttribute('data-size') || 0);
            });

            selectedCount.textContent = selected.length;
            if (selectedCourseCount) selectedCourseCount.textContent = courseCodes.size;
            if (selectedSize) selectedSize.textContent = formatBytes(size);
            downloadSelected.disabled = selected.length === 0;
            if (selected.length > 0 && validationMessage) {
                validationMessage.textContent = '';
            }

            courseToggles.forEach(function (toggle) {
                var courseCode = toggle.getAttribute('data-course-toggle');
                var courseCheckboxes = materialCheckboxes.filter(function (cb) {
                    return cb.getAttribute('data-course') === courseCode && !cb.disabled;
                });
                var checkedCourseItems = courseCheckboxes.filter(function (cb) {
                    return cb.checked;
                });
                toggle.checked = courseCheckboxes.length > 0
                        && checkedCourseItems.length === courseCheckboxes.length;
                toggle.indeterminate = checkedCourseItems.length > 0
                        && checkedCourseItems.length < courseCheckboxes.length;
            });
        }

        materialCheckboxes.forEach(function (cb) {
            cb.addEventListener('change', updateSelectionSummary);
        });

        courseToggles.forEach(function (toggle) {
            toggle.addEventListener('change', function () {
                var courseCode = toggle.getAttribute('data-course-toggle');
                materialCheckboxes.forEach(function (cb) {
                    if (cb.getAttribute('data-course') === courseCode && !cb.disabled) {
                        cb.checked = toggle.checked;
                    }
                });
                updateSelectionSummary();
            });
        });

        if (downloadAll) {
            downloadAll.addEventListener('click', function () {
                materialCheckboxes.forEach(function (cb) {
                    if (!cb.disabled) {
                        cb.checked = true;
                    }
                });
                updateSelectionSummary();
                form.requestSubmit();
            });
        }

        form.addEventListener('submit', function (event) {
            var hasSelection = materialCheckboxes.some(function (cb) {
                return cb.checked && !cb.disabled;
            });
            if (!hasSelection) {
                event.preventDefault();
                if (validationMessage) {
                    validationMessage.textContent = 'Select at least one available material.';
                }
            }
        });

        updateSelectionSummary();
    }

    function formatBytes(bytes) {
        if (!bytes) {
            return '0 B';
        }
        var units = ['B', 'KB', 'MB', 'GB'];
        var unitIndex = Math.min(
            Math.floor(Math.log(bytes) / Math.log(1024)),
            units.length - 1
        );
        var value = bytes / Math.pow(1024, unitIndex);
        return value.toFixed(unitIndex === 0 ? 0 : 1) + ' ' + units[unitIndex];
    }

    function debounce(callback, delay) {
        var timer;
        return function () {
            clearTimeout(timer);
            var args = arguments;
            timer = setTimeout(function () {
                callback.apply(null, args);
            }, delay);
        };
    }

    document.addEventListener('DOMContentLoaded', function () {
        initDependencyGraphs();
        initMaterialBrowser();
    });
})();
