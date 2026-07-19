<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- Later add JSTL taglibs --%>
<%-- <%@ taglib prefix="c" uri="jakarta.tags.core" %> --%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Syllabus Details</title>
    <!-- CSS File -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/syllabus-detail.css">
</head>
<body>

    <!-- 2. TOP HEADER -->
    <header class="syl-header">
        <div class="syl-header-left">
            <a href="${pageContext.request.contextPath}/" class="btn-home">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
                    <polyline points="9 22 9 12 15 12 15 22"></polyline>
                </svg>
                Home
            </a>
        </div>
        <div class="syl-header-center">
            <h1>FPT University Learning Materials</h1>
        </div>
        <div class="syl-header-right">
            <div class="lang-selector">
                <select>
                    <option value="en">English</option>
                    <option value="vi">Vietnamese</option>
                </select>
            </div>
            <div class="user-avatar">
                <%-- Later replace with dynamic avatar --%>
                AD
            </div>
        </div>
    </header>

    <!-- 1. GLOBAL PAGE LAYOUT: Main Container -->
    <main class="syl-container">
        
        <!-- 3. PAGE TITLE -->
        <h2 class="page-title">Syllabus Details</h2>

        <!-- 4. GENERAL SYLLABUS INFORMATION TABLE -->
        <table class="info-table">
            <tbody>
                <tr>
                    <th>Syllabus ID</th>
                    <%-- Later replace with ${syllabus.syllabusId} --%>
                    <td>14176</td>
                </tr>
                <tr>
                    <th>Syllabus Name</th>
                    <%-- Later replace with ${syllabus.syllabusName} --%>
                    <td>Software Requirement_Yêu cầu phần mềm</td>
                </tr>
                <tr>
                    <th>Syllabus English</th>
                    <%-- Later replace with ${syllabus.syllabusEnglish} --%>
                    <td>Software Requirement</td>
                </tr>
                <tr>
                    <th>Subject Code</th>
                    <%-- Later replace with ${syllabus.subjectCode} --%>
                    <td>SWR302</td>
                </tr>
                <tr>
                    <th>NoCredit</th>
                    <%-- Later replace with ${syllabus.noCredit} --%>
                    <td>3</td>
                </tr>
                <tr>
                    <th>Degree Level</th>
                    <%-- Later replace with ${syllabus.degreeLevel} --%>
                    <td>Bachelor</td>
                </tr>
                <tr>
                    <th>Time Allocation</th>
                    <%-- Later replace with ${syllabus.timeAllocation} --%>
                    <td>Study hour (150h) = 45h contact hours + 145-minute final exam + 102,6h self-study</td>
                </tr>
                <tr>
                    <th>Pre-Requisite</th>
                    <%-- Later replace with ${syllabus.preRequisite} --%>
                    <td>SWE102 or SWE201c or SWE202c</td>
                </tr>
                <tr>
                    <th>Description</th>
                    <%-- Later replace with ${syllabus.description} --%>
                    <td>This course is a model-based introduction to RE, providing the conceptual background and terminology on RE, addressing a variety of techniques for requirements development including Analysis and Requirements Elicitation; Requirements Evaluation; Requirements Specification and Documentation; Requirements Quality Assurance. To implement these frameworks, students will learn how to find appropriate customer representatives, elicit requirements from them, and document user requirements, business rules, functional requirements, data requirements, and nonfunctional requirements.

The numerous visual models that will be represented to illustrate the requirements from various perspectives to supplement natural-language text. Other contents recommend the most effective requirements approaches for various specific classes of projects: agile projects developing products of any type, enhancement and replacement projects, projects that incorporate packaged solutions, outsourced projects, business process automation projects, business analytics projects, and embedded and other real-time systems.</td>
                </tr>
                <tr>
                    <th>StudentTasks</th>
                    <%-- Later replace with ${syllabus.studentTasks} --%>
                    <td>- Students must attend at least 80% of contact slots in order to be accepted to the final examination.
- Student is responsible to do all exercises given by instructor in class or at home and submit on time.
- Promptly access to the https://flm.fpt.edu.vn/ for up-to-date course information.</td>
                </tr>
                <tr>
                    <th>Tools</th>
                    <%-- Later replace with ${syllabus.tools} --%>
                    <td>- Microsoft Office for documents and presentation.
- https://www.visual-paradigm.com/download/community.jsp students must install Visual Paradigm for drawing UML offline before taking Final Practical Exam.
- BOUML (http://bouml.free.fr/) : UML Drawing software.</td>
                </tr>
                <tr>
                    <th>Scoring Scale</th>
                    <%-- Later replace with ${syllabus.scoringScale} --%>
                    <td>10</td>
                </tr>
                <tr>
                    <th>DecisionNo MM/dd/yyyy</th>
                    <%-- Later replace with ${syllabus.decisionNo} --%>
                    <td>377/QĐ-ĐHFPT dated 04/09/2026</td>
                </tr>
                <tr>
                    <th>IsApproved</th>
                    <%-- Later replace with ${syllabus.isApproved} --%>
                    <td>True</td>
                </tr>
                <tr>
                    <th>Note</th>
                    <%-- Later replace with ${syllabus.note} --%>
                    <td>In the case: (5 > Final TE Score >=4) & (5 > Final PE Score >=4) & FR < 5, the student can choose to take the resit of both TE & PE OR just either TE or PE.</td>
                </tr>
                <tr>
                    <th>MinAvgMarkToPass</th>
                    <%-- Later replace with ${syllabus.minAvgMarkToPass} --%>
                    <td>5</td>
                </tr>
                <tr>
                    <th>IsActive</th>
                    <%-- Later replace with ${syllabus.isActive} --%>
                    <td>True</td>
                </tr>
                <tr>
                    <th>ApprovedDate</th>
                    <%-- Later replace with ${syllabus.approvedDate} --%>
                    <td>4/9/2026</td>
                </tr>
            </tbody>
        </table>

        <!-- 5. LEARNING MATERIALS SECTION -->
        <span class="section-meta">4 material(s)</span>
        
        <div class="table-responsive">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>MaterialDescription</th>
                        <th>Author</th>
                        <th>Publisher</th>
                        <th>PublishedDate</th>
                        <th>Edition</th>
                        <th>ISBN</th>
                        <th>IsMainMaterial</th>
                        <th>IsHardCopy</th>
                        <th>IsOnline</th>
                        <th>Note</th>
                    </tr>
                </thead>
                <tbody>
                    <%--
                    Later replace material rows with:
                    <c:forEach var="material" items="${materialList}">
                        ...
                    </c:forEach>
                    --%>
                    <!-- ROW 1 -->
                    <tr>
                        <td class="word-break-all">Software Requirements</td>
                        <td>Ellen Gottesdiener<br>Karl E. Wiegers</td>
                        <td>Microsoft Press</td>
                        <td></td>
                        <td>Third Edition</td>
                        <td>978-0-7356-7966-5</td>
                        <td class="checkbox-cell"><input type="checkbox" checked disabled></td>
                        <td class="checkbox-cell"><input type="checkbox" checked disabled></td>
                        <td class="checkbox-cell"><input type="checkbox" disabled></td>
                        <td></td>
                    </tr>
                    <!-- ROW 2 -->
                    <tr>
                        <td class="word-break-all">More About Software Requirements: Thorny Issues and Practical Advice</td>
                        <td>Karl E. Wiegers</td>
                        <td>Microsoft Press</td>
                        <td></td>
                        <td></td>
                        <td>978-0-7356-2267-8</td>
                        <td class="checkbox-cell"><input type="checkbox" disabled></td>
                        <td class="checkbox-cell"><input type="checkbox" checked disabled></td>
                        <td class="checkbox-cell"><input type="checkbox" disabled></td>
                        <td></td>
                    </tr>
                    <!-- ROW 3 -->
                    <tr>
                        <td class="word-break-all">The Software Requirements Memory Jogger: A Pocket Guide to Help Software And Business Teams Develop and Manage Requirements</td>
                        <td>Ellen Gottesdiener</td>
                        <td>GOAL/QPC</td>
                        <td></td>
                        <td></td>
                        <td>978-1-57681-060-6</td>
                        <td class="checkbox-cell"><input type="checkbox" disabled></td>
                        <td class="checkbox-cell"><input type="checkbox" checked disabled></td>
                        <td class="checkbox-cell"><input type="checkbox" disabled></td>
                        <td></td>
                    </tr>
                    <!-- ROW 4 -->
                    <tr>
                        <td class="word-break-all">Requirements Engineering: Secure Software Specifications Specialization</td>
                        <td></td>
                        <td>Coursera</td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td class="checkbox-cell"><input type="checkbox" disabled></td>
                        <td class="checkbox-cell"><input type="checkbox" disabled></td>
                        <td class="checkbox-cell"><input type="checkbox" checked disabled></td>
                        <td class="word-break-all"><a href="https://www.coursera.org/specializations/requirements-engineering-secure-software">https://www.coursera.org/specializations/requirements-engineering-secure-software</a></td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- 6. LEARNING OUTCOMES SECTION -->
        <span class="section-meta">9 LO(s)</span>
        
        <div class="table-responsive">
            <table class="data-table">
                <thead>
                    <tr>
                        <th style="width: 50px; text-align: center;"></th>
                        <th style="width: 120px;">CLO Name</th>
                        <th>CLO Details</th>
                        <th>LO Details</th>
                    </tr>
                </thead>
                <tbody>
                    <%--
                    Later replace learning outcomes with:
                    <c:forEach var="lo" items="${learningOutcomeList}">
                        ...
                    </c:forEach>
                    --%>
                    <tr>
                        <td style="text-align: center;">1</td>
                        <td>CLO1</td>
                        <td></td>
                        <td>Develop a good understanding of principles and techniques for requirement engineering (RE) regarding requirement inception, requirement development (elicitation, analysis, specification, validation) and requirement management; understand main characteristics of specific projects</td>
                    </tr>
                    <tr>
                        <td style="text-align: center;">2</td>
                        <td>CLO2</td>
                        <td></td>
                        <td>Identify the appropriate requirements elicitation techniques to identify requirements</td>
                    </tr>
                    <tr>
                        <td style="text-align: center;">3</td>
                        <td>CLO3</td>
                        <td></td>
                        <td>Utilize various requirements validation techniques to critically evaluate their requirements to identify defects</td>
                    </tr>
                    <tr>
                        <td style="text-align: center;">4</td>
                        <td>CLO4</td>
                        <td></td>
                        <td>Analysis of system requirements and the production of system specifications</td>
                    </tr>
                    <tr>
                        <td style="text-align: center;">5</td>
                        <td>CLO5</td>
                        <td></td>
                        <td>Create models of requirements using a variety of notations and techniques, including domain and usage models</td>
                    </tr>
                    <tr>
                        <td style="text-align: center;">6</td>
                        <td>CLO6</td>
                        <td></td>
                        <td>Design and plan software solutions to problems using an object-oriented strategy</td>
                    </tr>
                    <tr>
                        <td style="text-align: center;">7</td>
                        <td>CLO7</td>
                        <td></td>
                        <td>Prepare and deliver coherent and structured verbal and written technical reports</td>
                    </tr>
                    <tr>
                        <td style="text-align: center;">8</td>
                        <td>CLO8</td>
                        <td></td>
                        <td>Understand how to reduce risks by prototyping.</td>
                    </tr>
                    <tr>
                        <td style="text-align: center;">9</td>
                        <td>CLO9</td>
                        <td></td>
                        <td>Utilize the tactic of requirements management regarding changing, tracing and improving requirements</td>
                    </tr>
                </tbody>
            </table>
        </div>
        
        <a href="#" class="mapping-link">View mapping of CLOs to PLOs</a>

        <!-- 7. COURSE SCHEDULE SECTION -->
        <div style="display: flex; align-items: baseline; gap: 1rem;">
            <a href="#" class="btn-download">Download All Student Material</a>
            <span class="section-meta">60 sessions (45'/session)</span>
        </div>
        
        <div class="table-responsive">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Session</th>
                        <th>Topic</th>
                        <th>Learning-Teaching Type</th>
                        <th>LO</th>
                        <th>ITU</th>
                        <th>Student Materials</th>
                        <th>S-Download</th>
                        <th>Student's Tasks</th>
                        <th>URLs</th>
                    </tr>
                </thead>
                <tbody>
                    <%--
                    Later replace schedule rows with:
                    <c:forEach var="session" items="${scheduleList}">
                        ...
                    </c:forEach>
                    --%>
                    <!-- ROW 1 -->
                    <tr>
                        <td>1</td>
                        <td>Course Introduction
The essential of software requirement
- Software requirements defined</td>
                        <td>Offline</td>
                        <td>LO1</td>
                        <td>I</td>
                        <td>Chapter 1 + Slides</td>
                        <td><a href="#">SWR302</a></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <!-- ROW 2 -->
                    <tr>
                        <td>2</td>
                        <td>The essential of software requirement (cnt)
- Requirements development and management
- When bad requirements happen to good people
- Benefits from a high-quality requirements process</td>
                        <td>Offline</td>
                        <td>LO1</td>
                        <td>I</td>
                        <td>Chapter 1 + Slides</td>
                        <td><a href="#">SWR302</a></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <!-- ROW 3 -->
                    <tr>
                        <td>3</td>
                        <td>Requirements from the customer's perspective
- Who is the customer?
- The customer-development partnership
- Creating a culture that respects requirement</td>
                        <td>Offline</td>
                        <td>LO1</td>
                        <td>I,T</td>
                        <td>Chapter 2
+ Slides</td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <!-- ROW 4 -->
                    <tr>
                        <td>4</td>
                        <td>Requirements from the customer's perspective (cnt)
- Identifying decision makers
- Reaching agreement on requirements
Assignment introduction</td>
                        <td>Offline</td>
                        <td>LO1</td>
                        <td>I,T</td>
                        <td>Chapter 2
+ Slides</td>
                        <td></td>
                        <td>do homework</td>
                        <td></td>
                    </tr>
                    <!-- ROW 5 -->
                    <tr>
                        <td>5</td>
                        <td>Good practices for requirements engineering (introduce)
- A requirements development process framework
- Requirements elicitation
- Requirements analysis
- Requirements specification
- Requirements validation
- Requirements management</td>
                        <td>Offline</td>
                        <td>LO1, LO2</td>
                        <td>I,T</td>
                        <td>Chapter 3
+Slides</td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <!-- ROW 6 -->
                    <tr>
                        <td>6</td>
                        <td>Good practices for requirements engineering (practice/apply)</td>
                        <td>Offline</td>
                        <td>LO1, LO2</td>
                        <td>I,T</td>
                        <td>Chapter 3
+Slides</td>
                        <td></td>
                        <td>do homework</td>
                        <td></td>
                    </tr>
                    <!-- ROW 7 -->
                    <tr>
                        <td>7</td>
                        <td>Group discussion
Summary and Exercises (groups)</td>
                        <td>Offline</td>
                        <td>LO2, LO4, LO5</td>
                        <td></td>
                        <td>Chapter 4+ Business Analyst Job Description.docx + Slides</td>
                        <td></td>
                        <td>Discuss what students have to do in their Assignment</td>
                        <td></td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- 8. CONSTRUCTIVE QUESTIONS COUNT -->
        <span class="section-meta" style="margin-bottom: 2rem;">0 Constructive question(s)</span>

        <!-- 9. ASSESSMENTS SECTION -->
        <span class="section-meta">6 assessment(s)</span>
        
        <div class="table-responsive">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Category</th>
                        <th>Type</th>
                        <th>Part</th>
                        <th>Weight</th>
                        <th>Completion Criteria</th>
                        <th>Duration</th>
                        <th>CLO</th>
                        <th>Question Type</th>
                        <th>No Question</th>
                        <th>Knowledge and Skill</th>
                        <th>Grading Guide</th>
                        <th>Note</th>
                    </tr>
                </thead>
                <tbody>
                    <%--
                    Later replace assessments with:
                    <c:forEach var="assessment" items="${assessmentList}">
                        ...
                    </c:forEach>
                    --%>
                    <!-- ROW 1 -->
                    <tr>
                        <td>Assignment</td>
                        <td>on-going</td>
                        <td>1</td>
                        <td>20.0%</td>
                        <td>>0</td>
                        <td>Option 1: 26 slots;
Option 2 (For Constructivism Approach only): Follow lecturer's proposal</td>
                        <td>LO1, LO2,
LO3,
LO4,
LO5,
LO6, LO7,
LO8</td>
                        <td>Option 1: Teacher raise projects, students practice step by step to complete their assignments. Student could based on study guide COS_Document_Example to do assignments.
Option 2 (For Constructivism Approach only): Follow lecturer's proposal</td>
                        <td>Option 1: Depending on questions in assignment
Option 2 (For Constructivism Approach only): Follow lecturer's proposal</td>
                        <td>All subjects in syllabus</td>
                        <td>in class, by teacher</td>
                        <td></td>
                    </tr>
                    <!-- ROW 2 -->
                    <tr>
                        <td>LAB</td>
                        <td>on-going</td>
                        <td>1</td>
                        <td>10.0%</td>
                        <td>>0</td>
                        <td>Option 1: 26slots/each option 2 (For Constructivism Approach only): Follow lecturer's proposal</td>
                        <td>LO5</td>
                        <td>1. Model 1 Context diagram based on the topic of assignment.
2. Model 1 Swimlane diagram based on the topic of assignment.
3. Model 1 State diagram based on the topic of assignment.</td>
                        <td>Option 1: Depending on questions in assignment
Option 2 (For Constructivism Approach only): Follow lecturer's proposal</td>
                        <td>Chapter 5,
Chapter 12</td>
                        <td>In class, by teacher</td>
                        <td>The output of LAB: draw 1 Context diagram, 1 Swimlane diagram and 1 State diagram. These diagrams will be drawn by individuals and will be presented by each student at week 7. After presenting LAB, the student will put these diagrams on his or her Assignment document.</td>
                    </tr>
                    <!-- ROW 3 -->
                    <tr>
                        <td>Progress Test</td>
                        <td>on-going</td>
                        <td>3</td>
                        <td>20.0%</td>
                        <td>>0</td>
                        <td>Option 1: 30'/each;
Option 2 (For Constructivism Approach only): Follow lecturer's proposal</td>
                        <td>LO1, LO2,
LO3,
LO4,
LO5,
LO6, LO7,
LO8, LO9</td>
                        <td>Option 1: Multiple choices Marked by Computer or a suitable format;
Option 2 (For Constructivism Approach only): Follow lecturer's proposal</td>
                        <td>Option 1: 30/each;
Option 2 (For Constructivism Approach only): Follow lecturer's proposal</td>
                        <td>Test 1: Chapter 1 → Chapter 9
Test 2: Chapter 10 → 20
Test 3: Chapter 21 → 32</td>
                        <td>in class, by LMS system</td>
                        <td></td>
                    </tr>
                    <!-- ROW 4 -->
                    <tr>
                        <td>Final exam</td>
                        <td>Final exam</td>
                        <td>2</td>
                        <td>50.0%</td>
                        <td>4</td>
                        <td>145 minutes</td>
                        <td>All CLOs</td>
                        <td></td>
                        <td></td>
                        <td>All subjects in syllabus</td>
                        <td>By exam board
Manual evaluating</td>
                        <td>Each part of the final exam must be >=4/10 & Final Result >=5/10.</td>
                    </tr>
                    <!-- ROW 5 -->
                    <tr>
                        <td>Practical Exam</td>
                        <td>Final exam</td>
                        <td>1</td>
                        <td>25.0%</td>
                        <td>4</td>
                        <td>85'</td>
                        <td>LO1, LO2,
LO3,
LO4,
LO5, LO7,
LO8, LO9</td>
                        <td></td>
                        <td></td>
                        <td>All subjects in syllabus</td>
                        <td>LSM system</td>
                        <td>Customized from the Assignment or projects that students have learned</td>
                    </tr>
                    <!-- ROW 6 -->
                    <tr>
                        <td>Final Theory Exam</td>
                        <td>Final exam</td>
                        <td>1</td>
                        <td>25.0%</td>
                        <td>4</td>
                        <td>60'</td>
                        <td>LO1, LO2, LO3, LO4, LO5, LO6, LO8, LO9</td>
                        <td>Multiple choice and short answer questions</td>
                        <td>40 questions</td>
                        <td>All theoretical contents in syllabus</td>
                        <td>LMS system</td>
                        <td>Students must achieve at least 4/10 for this component.</td>
                    </tr>
                </tbody>
            </table>
        </div>

    </main>

    <!-- 10. FLOATING SUPPORT BUTTON -->
    <a href="#" class="btn-support-floating">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"></path>
        </svg>
    </a>

</body>
</html>
