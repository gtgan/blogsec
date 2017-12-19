<%@ include file="top.jsp" %>
        <title>BlogSec</title>
    </head>
<c:if test="${param.out != null}"><% session.removeAttribute("loginUser"); %></c:if>
<%@ include file="nav.jsp" %>
        <h1>Users</h1><hr/>
        <sql:query dataSource="jdbc/blogsec" var="result">
            SELECT email, first_name, last_name, privilege FROM Users ORDER BY privilege DESC;
        </sql:query>
        <table width="100%">
            <thead><tr>
                <th>Email</th>
                <th>Name</th>
                <th>Privilege</th>
            </tr></thead>
            <tbody>
                <c:forEach var="row" items="${result.rows}"><tr>
                    <td><c:out value="${row.email}"/></td>
                    <td><c:out value="${row.first_name} ${row.last_name}"/></td>
                    <td><c:out value="${row.privilege}"/></td>
                </tr></c:forEach>
            </tbody>
        </table>
<%@ include file="bottom.html" %>
