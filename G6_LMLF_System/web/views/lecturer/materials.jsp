<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="content-header">
    <div>
        <h2>Teaching Materials</h2>
        <p>Manage your personal teaching materials and share them with colleagues.</p>
    </div>
    <div>
        <button class="btn-primary" onclick="openUploadModal()">
            <svg fill="none" stroke="currentColor" viewBox="0 0 24 24" width="20" height="20">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
            </svg>
            Upload Material
        </button>
    </div>
</div>

<c:if test="${not empty sessionScope.successMsg}">
    <div style="background-color: #d1fae5; color: #065f46; padding: 1rem; border-radius: 6px; margin-bottom: 1rem;">
        ${sessionScope.successMsg}
        <c:remove var="successMsg" scope="session"/>
    </div>
</c:if>
<c:if test="${not empty sessionScope.errorMsg}">
    <div style="background-color: #fee2e2; color: #991b1b; padding: 1rem; border-radius: 6px; margin-bottom: 1rem;">
        ${sessionScope.errorMsg}
        <c:remove var="errorMsg" scope="session"/>
    </div>
</c:if>

<div class="panel">
    <!-- Tabs -->
    <div class="panel-header" style="display: flex; gap: 1rem; border-bottom: none; padding-bottom: 0;">
        <div style="display: flex; gap: 2rem; border-bottom: 2px solid #e2e8f0; width: 100%;">
            <a href="${pageContext.request.contextPath}/lecturer/materials?tab=my" 
               style="padding: 0.5rem 1rem; cursor: pointer; text-decoration: none; font-weight: 600; margin-bottom: -2px;
                      ${activeTab == 'my' || empty activeTab ? 'color: #f26f21; border-bottom: 2px solid #f26f21;' : 'color: #64748b;'}">
                My Uploads
            </a>
            <a href="${pageContext.request.contextPath}/lecturer/materials?tab=shared" 
               style="padding: 0.5rem 1rem; cursor: pointer; text-decoration: none; font-weight: 600; margin-bottom: -2px;
                      ${activeTab == 'shared' ? 'color: #f26f21; border-bottom: 2px solid #f26f21;' : 'color: #64748b;'}">
                Shared with me
            </a>
        </div>
    </div>
    
    <div class="panel-header" style="display: flex; gap: 1rem; flex-wrap: wrap; border-top: 1px solid #e2e8f0; margin-top: -1px;">
        <h3 class="panel-title" style="min-width: 150px;">
            ${activeTab == 'shared' ? 'Materials Shared With You' : 'Your Materials'}
        </h3>
        <div style="display: flex; gap: 10px; flex: 1; justify-content: flex-end;">
            <input type="text" placeholder="Search Materials..." style="padding: 8px 12px; border: 1px solid #e2e8f0; border-radius: 6px; outline: none; width: 250px;">
            <select style="padding: 8px 12px; border: 1px solid #e2e8f0; border-radius: 6px; outline: none;">
                <option value="">All Categories</option>
                <option value="Lecture Slides">Lecture Slides</option>
                <option value="Sample Code">Sample Code</option>
            </select>
        </div>
    </div>
    
    <div class="panel-body">
        <table style="width: 100%; border-collapse: collapse; text-align: left;">
            <thead>
                <tr style="background-color: #f8fafc; border-bottom: 2px solid #e2e8f0;">
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Material Name</th>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Category</th>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Type</th>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Date</th>
                    <c:if test="${activeTab == 'shared'}">
                        <th style="padding: 1rem; color: #64748b; font-size: 0.875rem;">Shared By</th>
                    </c:if>
                    <th style="padding: 1rem; color: #64748b; font-size: 0.875rem; text-align: right;">Action</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${empty materialList}">
                        <tr>
                            <td colspan="6" style="padding: 2rem; text-align: center; color: #64748b;">No materials found.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="mat" items="${materialList}">
                            <tr style="border-bottom: 1px solid #f1f5f9; transition: background-color 0.2s;" onmouseover="this.style.backgroundColor='#f8fafc'" onmouseout="this.style.backgroundColor='transparent'">
                                <td style="padding: 1rem; font-weight: 600; color: #1e293b;">
                                    ${mat.title}
                                </td>
                                <td style="padding: 1rem;">${mat.category}</td>
                                <td style="padding: 1rem;">
                                    <span style="padding: 4px 10px; border-radius: 12px; font-size: 0.75rem; font-weight: bold; 
                                          ${mat.materialType == 'LINK' ? 'background-color: #e0e7ff; color: #4338ca;' : 'background-color: #fce7f3; color: #be185d;'}">
                                        ${mat.materialType}
                                    </span>
                                </td>
                                <td style="padding: 1rem;">
                                    <fmt:formatDate value="${mat.uploadedAt}" pattern="MMM dd, yyyy HH:mm"/>
                                </td>
                                <c:if test="${activeTab == 'shared'}">
                                    <td style="padding: 1rem;">${mat.sharedByEmail}</td>
                                </c:if>
                                <td style="padding: 1rem; text-align: right; display: flex; gap: 0.5rem; justify-content: flex-end;">
                                    <c:if test="${mat.materialType == 'LINK'}">
                                        <a href="${mat.fileUrl}" target="_blank" class="action-button" style="padding: 6px 12px; font-size: 0.75rem; text-decoration: none;">Open Link</a>
                                    </c:if>
                                    <c:if test="${mat.materialType == 'FILE'}">
                                        <a href="${pageContext.request.contextPath}/download?path=${mat.fileUrl}" class="action-button" style="padding: 6px 12px; font-size: 0.75rem; text-decoration: none;">Download</a>
                                    </c:if>
                                    
                                    <c:if test="${activeTab != 'shared'}">
                                        <button class="action-button" onclick="openShareModal(${mat.lecturerMaterialId}, '${mat.title}', '${mat.materialType}')" style="padding: 6px 12px; font-size: 0.75rem; color: #10b981; border-color: #34d399;">Share</button>
                                        <form action="${pageContext.request.contextPath}/lecturer/materials" method="POST" style="display:inline;" onsubmit="return confirm('Delete this material?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="materialId" value="${mat.lecturerMaterialId}">
                                            <button type="submit" class="action-button" style="padding: 6px 12px; font-size: 0.75rem; color: #e74c3c; border-color: #fca5a5;">Delete</button>
                                        </form>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</div>

<!-- Upload Modal -->
<div id="uploadModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 1000; align-items: center; justify-content: center;">
    <div style="background: white; padding: 2rem; border-radius: 8px; width: 500px; max-width: 90%;">
        <h3 style="margin-top: 0;">Upload / Add Material</h3>
        <form action="${pageContext.request.contextPath}/lecturer/materials" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="action" value="upload">
            
            <div style="margin-bottom: 1rem;">
                <label style="display: block; margin-bottom: 0.5rem; font-weight: bold;">Title</label>
                <input type="text" name="title" required style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
            </div>
            
            <div style="margin-bottom: 1rem;">
                <label style="display: block; margin-bottom: 0.5rem; font-weight: bold;">Category</label>
                <select name="category" required style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
                    <option value="Lecture Slides">Lecture Slides</option>
                    <option value="Sample Code">Sample Code</option>
                    <option value="Case Studies">Case Studies</option>
                    <option value="Past Exams">Past Exams</option>
                    <option value="Other">Other</option>
                </select>
            </div>
            
            <div style="margin-bottom: 1rem;">
                <label style="display: block; margin-bottom: 0.5rem; font-weight: bold;">Material Type</label>
                <div style="display: flex; gap: 1rem;">
                    <label><input type="radio" name="materialType" value="FILE" checked onchange="toggleType()"> Upload File</label>
                    <label><input type="radio" name="materialType" value="LINK" onchange="toggleType()"> External Link</label>
                </div>
            </div>
            
            <div id="fileInputDiv" style="margin-bottom: 1rem;">
                <label style="display: block; margin-bottom: 0.5rem; font-weight: bold;">Select File</label>
                <input type="file" name="fileUpload" style="width: 100%;">
            </div>
            
            <div id="linkInputDiv" style="margin-bottom: 1rem; display: none;">
                <label style="display: block; margin-bottom: 0.5rem; font-weight: bold;">URL Link</label>
                <input type="url" name="linkUrl" placeholder="https://..." style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
            </div>
            
            <div style="display: flex; justify-content: flex-end; gap: 1rem; margin-top: 2rem;">
                <button type="button" onclick="closeUploadModal()" style="padding: 8px 16px; border: 1px solid #ccc; background: white; border-radius: 4px; cursor: pointer;">Cancel</button>
                <button type="submit" class="btn-primary" style="padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer;">Save Material</button>
            </div>
        </form>
    </div>
</div>

<!-- Share Modal -->
<div id="shareModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 1000; align-items: center; justify-content: center;">
    <div style="background: white; padding: 2rem; border-radius: 8px; width: 400px; max-width: 90%;">
        <h3 style="margin-top: 0;">Share Material via Email</h3>
        <p style="color: #64748b; font-size: 0.875rem;">An email notification will be sent to your colleague.</p>
        <form action="${pageContext.request.contextPath}/lecturer/materials" method="POST">
            <input type="hidden" name="action" value="share">
            <input type="hidden" name="materialId" id="shareMaterialId">
            <input type="hidden" name="materialTitle" id="shareMaterialTitle">
            <input type="hidden" name="materialType" id="shareMaterialType">
            
            <div style="margin-bottom: 1rem;">
                <label style="display: block; margin-bottom: 0.5rem; font-weight: bold;">Colleague's Email</label>
                <input type="email" name="shareEmail" required placeholder="lecturer@fpt.edu.vn" style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
            </div>
            
            <div style="display: flex; justify-content: flex-end; gap: 1rem; margin-top: 2rem;">
                <button type="button" onclick="closeShareModal()" style="padding: 8px 16px; border: 1px solid #ccc; background: white; border-radius: 4px; cursor: pointer;">Cancel</button>
                <button type="submit" class="btn-primary" style="padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer;">Send</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openUploadModal() {
        document.getElementById('uploadModal').style.display = 'flex';
    }
    function closeUploadModal() {
        document.getElementById('uploadModal').style.display = 'none';
    }
    function toggleType() {
        const type = document.querySelector('input[name="materialType"]:checked').value;
        if (type === 'FILE') {
            document.getElementById('fileInputDiv').style.display = 'block';
            document.getElementById('linkInputDiv').style.display = 'none';
        } else {
            document.getElementById('fileInputDiv').style.display = 'none';
            document.getElementById('linkInputDiv').style.display = 'block';
        }
    }
    
    function openShareModal(id, title, type) {
        document.getElementById('shareMaterialId').value = id;
        document.getElementById('shareMaterialTitle').value = title;
        document.getElementById('shareMaterialType').value = type;
        document.getElementById('shareModal').style.display = 'flex';
    }
    function closeShareModal() {
        document.getElementById('shareModal').style.display = 'none';
    }
</script>
