<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- Later add JSTL taglibs --%>
<%-- <%@ taglib prefix="c" uri="jakarta.tags.core" %> --%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Curriculum Details - LMLF</title>
    <!-- Use exactly the CSS we just created -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/curriculum-detail.css">
    
    <!-- Using inline SVG icons to avoid external dependencies for static mockup -->
</head>
<body>

    <!-- 1. Top Header -->
    <header class="curr-header">
        <div class="curr-header-left">
            <a href="javascript:history.back()" class="btn-back">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="19" y1="12" x2="5" y2="12"></line>
                    <polyline points="12 19 5 12 12 5"></polyline>
                </svg>
                Back
            </a>
        </div>
        <div class="curr-header-center">
            <h1>FPT University Learning Materials</h1>
        </div>
        <div class="curr-header-right">
            <div class="lang-selector">
                <select>
                    <option value="en">EN</option>
                    <option value="vi">VI</option>
                </select>
            </div>
            <div class="user-avatar">
                <%-- Later replace with ${sessionScope.user.username.substring(0,2).toUpperCase()} --%>
                AD
            </div>
        </div>
    </header>

    <!-- 2. Main Content -->
    <main class="curr-container">
        
        <h2 class="page-title">Curriculum Details</h2>

        <!-- 3. Curriculum General Information Table -->
        <table class="info-table">
            <tbody>
                <tr>
                    <th>CurriculumCode</th>
                    <%-- Later replace with ${curriculum.code} --%>
                    <td>BIT_SE_K20B</td>
                </tr>
                <tr>
                    <th>Name</th>
                    <%-- Later replace with ${curriculum.name} --%>
                    <td>
                        Bachelor Program of Information Technology, Software Engineering Major<br>
                        <span style="color: var(--text-muted); font-size: 0.9em;">(Chương trình cử nhân ngành Công nghệ thông tin, chuyên ngành Kỹ thuật phần mềm)</span>
                    </td>
                </tr>
                <tr>
                    <th>Description</th>
                    <%-- Later replace with ${curriculum.description} --%>
                    <td style="line-height: 1.6;">
                        This curriculum provides students with a solid foundation in software engineering, preparing them for careers as software developers, system analysts, and IT consultants. 
                        It covers core concepts in programming, algorithms, database systems, and software design patterns. <br><br>
                        <span style="color: var(--text-muted);">Chương trình đào tạo này cung cấp cho sinh viên nền tảng vững chắc về kỹ thuật phần mềm, chuẩn bị cho họ các nghề nghiệp như lập trình viên, chuyên viên phân tích hệ thống và cố vấn CNTT. 
                        Nội dung bao gồm các khái niệm cốt lõi về lập trình, thuật toán, hệ cơ sở dữ liệu và các mẫu thiết kế phần mềm.</span>
                    </td>
                </tr>
                <tr>
                    <th>DecisionNo MM/dd/yyyy</th>
                    <%-- Later replace with ${curriculum.decisionNumber} --%>
                    <td>577/QĐ-ĐHFPT 05/15/2026</td>
                </tr>
                <tr>
                    <th>Total Credit</th>
                    <%-- Later replace with ${curriculum.totalCredit} --%>
                    <td>145</td>
                </tr>
            </tbody>
        </table>

        <!-- 4. Action Buttons -->
        <div class="curr-actions">
            <button class="btn-action">View PO</button>
            <button class="btn-action">View Combo</button>
            <button class="btn-action">View Elective</button>
        </div>

        <!-- 5. Program Learning Outcomes Section -->
        <div class="section-header">
            <h3 class="section-title">Program Learning Outcomes</h3>
            <%-- Later dynamically count PLOs with ${ploList.size()} --%>
            <span class="section-meta">13 PLO(s) found</span>
        </div>
        
        <div class="data-table-container">
            <table class="data-table">
                <thead>
                    <tr>
                        <th style="width: 8%;">No.</th>
                        <th style="width: 20%;">PLO Name</th>
                        <th>PLO Description</th>
                    </tr>
                </thead>
                <tbody>
                    <%-- Later replace with: <c:forEach var="plo" items="${ploList}" varStatus="status"> --%>
                    <tr>
                        <td>1</td>
                        <td>PLO1</td>
                        <td>Apply knowledge of mathematics, science, and engineering to software engineering problems.</td>
                    </tr>
                    <tr>
                        <td>2</td>
                        <td>PLO2</td>
                        <td>Analyze a complex computing problem and to apply principles of computing and other relevant disciplines to identify solutions.</td>
                    </tr>
                    <tr>
                        <td>3</td>
                        <td>PLO3</td>
                        <td>Design, implement, and evaluate a computing-based solution to meet a given set of computing requirements in the context of the program's discipline.</td>
                    </tr>
                    <tr>
                        <td>4</td>
                        <td>PLO4</td>
                        <td>Communicate effectively in a variety of professional contexts.</td>
                    </tr>
                    <tr>
                        <td>5</td>
                        <td>PLO5</td>
                        <td>Recognize professional responsibilities and make informed judgments in computing practice based on legal and ethical principles.</td>
                    </tr>
                    <tr>
                        <td>6</td>
                        <td>PLO6</td>
                        <td>Function effectively as a member or leader of a team engaged in activities appropriate to the program's discipline.</td>
                    </tr>
                    <tr>
                        <td>7</td>
                        <td>PLO7</td>
                        <td>Identify and analyze user needs and to take them into account in the selection, creation, integration, evaluation, and administration of computing-based systems.</td>
                    </tr>
                    <tr>
                        <td>8</td>
                        <td>PLO8</td>
                        <td>Integrate IT-based solutions into the user environment effectively.</td>
                    </tr>
                    <tr>
                        <td>9</td>
                        <td>PLO9</td>
                        <td>Understand best practices and standards and their application.</td>
                    </tr>
                    <tr>
                        <td>10</td>
                        <td>PLO10</td>
                        <td>Assist in the creation of an effective project plan.</td>
                    </tr>
                    <tr>
                        <td>11</td>
                        <td>PLO11</td>
                        <td>Demonstrate the ability to learn and adapt to new technologies, paradigms, and practices.</td>
                    </tr>
                    <tr>
                        <td>12</td>
                        <td>PLO12</td>
                        <td>Demonstrate an understanding of entrepreneurship and innovation in the IT industry.</td>
                    </tr>
                    <tr>
                        <td>13</td>
                        <td>PLO13</td>
                        <td>Communicate in English proficiently, enabling work in international environments.</td>
                    </tr>
                    <%-- </c:forEach> --%>
                </tbody>
            </table>
        </div>

        <!-- 6. Subjects Section -->
        <div class="section-header">
            <h3 class="section-title">Subjects</h3>
            <%-- Later dynamically count subjects with ${subjectList.size()} and total credits --%>
            <span class="section-meta">48 subjects, 145 credits</span>
        </div>

        <div class="data-table-container">
            <table class="data-table">
                <thead>
                    <tr>
                        <th style="width: 15%;">Subject Code</th>
                        <th style="width: 45%;">Subject Name</th>
                        <th style="width: 10%;">Semester</th>
                        <th style="width: 10%;">No. Credit</th>
                        <th style="width: 20%;">Prerequisite</th>
                    </tr>
                </thead>
                <tbody>
                    <%-- Later replace with: <c:forEach var="subject" items="${subjectList}"> --%>
                    <tr>
                        <td><a href="#" class="subject-link">OTP101</a></td>
                        <td>Orientation program</td>
                        <td>1</td>
                        <td>0</td>
                        <td></td>
                    </tr>
                    <tr>
                        <td><a href="#" class="subject-link">PEN</a></td>
                        <td>Preparation English</td>
                        <td>1</td>
                        <td>0</td>
                        <td></td>
                    </tr>
                    <tr>
                        <td><a href="#" class="subject-link">PHE_COM*1</a></td>
                        <td>Physical Education 1</td>
                        <td>1</td>
                        <td>3</td>
                        <td></td>
                    </tr>
                    <tr>
                        <td><a href="#" class="subject-link">TMI_ELE</a></td>
                        <td>Traditional Musical Instrument (TMI)</td>
                        <td>1</td>
                        <td>3</td>
                        <td></td>
                    </tr>
                    <tr>
                        <td><a href="#" class="subject-link">CEA201</a></td>
                        <td>Computer Organization and Architecture</td>
                        <td>1</td>
                        <td>3</td>
                        <td></td>
                    </tr>
                    <tr>
                        <td><a href="#" class="subject-link">CSI106</a></td>
                        <td>Introduction to Computer Science</td>
                        <td>1</td>
                        <td>3</td>
                        <td></td>
                    </tr>
                    <tr>
                        <td><a href="#" class="subject-link">MAE101</a></td>
                        <td>Mathematics for Engineering</td>
                        <td>1</td>
                        <td>3</td>
                        <td></td>
                    </tr>
                    <tr>
                        <td><a href="#" class="subject-link">PRF192</a></td>
                        <td>Programming Fundamentals</td>
                        <td>1</td>
                        <td>3</td>
                        <td></td>
                    </tr>
                    <tr>
                        <td><a href="#" class="subject-link">SSL101c</a></td>
                        <td>Academic Skills for University Success</td>
                        <td>1</td>
                        <td>3</td>
                        <td></td>
                    </tr>
                    <tr>
                        <td><a href="#" class="subject-link">MAD101</a></td>
                        <td>Discrete mathematics</td>
                        <td>2</td>
                        <td>3</td>
                        <td></td>
                    </tr>
                    <tr>
                        <td><a href="#" class="subject-link">NWC204</a></td>
                        <td>Computer Networking</td>
                        <td>2</td>
                        <td>3</td>
                        <td>CEA201</td>
                    </tr>
                    <tr>
                        <td><a href="#" class="subject-link">OSG202</a></td>
                        <td>Operating Systems</td>
                        <td>2</td>
                        <td>3</td>
                        <td>CEA201</td>
                    </tr>
                    <tr>
                        <td><a href="#" class="subject-link">PHE_COM*3</a></td>
                        <td>Physical Education 3</td>
                        <td>2</td>
                        <td>3</td>
                        <td>PHE_COM*1</td>
                    </tr>
                    <tr>
                        <td><a href="#" class="subject-link">PRO192</a></td>
                        <td>Object-Oriented Programming</td>
                        <td>2</td>
                        <td>3</td>
                        <td>PRF192</td>
                    </tr>
                    <tr>
                        <td><a href="#" class="subject-link">WED201c</a></td>
                        <td>Web Design</td>
                        <td>2</td>
                        <td>3</td>
                        <td>PRF192</td>
                    </tr>
                    <tr>
                        <td><a href="#" class="subject-link">DBI202</a></td>
                        <td>Introduction to Databases</td>
                        <td>3</td>
                        <td>3</td>
                        <td>PRO192</td>
                    </tr>
                    <%-- </c:forEach> --%>
                </tbody>
            </table>
        </div>
        
    </main>

</body>
</html>
