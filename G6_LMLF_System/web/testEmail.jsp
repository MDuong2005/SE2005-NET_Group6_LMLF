<%@ page import="utils.EmailUtil" %>
<%
    boolean result = EmailUtil.sendGuestCredentials("maid88391@gmail.com", "123456", "Guest Test");
    out.println("Email send test from Tomcat: " + result);
%>
