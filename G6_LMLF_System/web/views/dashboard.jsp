<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
</head>
<body>

<h1>Login Success</h1>

<p>
    Welcome:
    ${sessionScope.user.email}
</p>

</body>
</html>