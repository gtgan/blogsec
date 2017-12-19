<%@ include file="top.jsp" %>
        <title>
            BlogSec
        <c:if test="${not empty param.mail}">
            | <c:out value="${param.mail}"/>
        </c:if>
        </title>
    </head>
<c:if test="${param.out != null}"><% session.removeAttribute("loginUser"); %></c:if>
<%@ include file="nav.jsp" %>
<c:choose>
    <c:when test="${empty param.mail}">
        <h1>Users</h1><hr/>
        <sql:query dataSource="jdbc/blogsec" var="result">
            SELECT email, first_name, last_name, bio, privilege FROM Users ORDER BY privilege DESC;
        </sql:query>
        <table width="100%">
            <thead><tr>
                <th>User</th>
                <th>Bio</th>
                <th>Privilege</th>
            </tr></thead>
            <tbody>
                <c:forEach var="row" items="${result.rows}"><tr>
                    <c:set var="uname" value="${row.first_name} ${row.last_name}"/>
                    <c:if test="${uname eq ' '}"><c:set var="uname" value="${row.email}"/></c:if>
                    <a href="users.jsp?mail=${row.email}"><td><c:out value="${uname}"/></td></a>
                    <td><c:out value="${row.bio}"/></td>
                    <td><c:out value="${row.privilege}"/></td>
                </tr></c:forEach>
            </tbody>
        </table>
    </c:when>
    <c:otherwise>
        <c:if test="${not empty param.bio && param.mail eq sessionScope['loginUser']}">
            <sql:update dataSource="jdbc/blogsec" var="r">
                UPDATE Users SET bio = ? WHERE email = ?;
                <sql:param value="${param.bio}"/>
                <sql:param value="${param.mail}"/>
            </sql:update>
        </c:if>
        <sql:query dataSource="jdbc/blogsec" var="uinfo">
            SELECT * FROM Users WHERE email = ?;
            <sql:param value="${param.mail}"/>
        </sql:query>
        <c:forEach var="user" items="${uinfo.rows}"><div>
            <c:set var="uname" value="${user.first_name} ${user.last_name}"/>
            <c:if test="${uname eq ' '}"><c:set var="uname" value="${row.email}"/></c:if>
            <h1><c:out value="${uname}"/></h1><hr/>
            <h3><c:out value="${user.email}"/></h3>
            Privileges: <c:out value="${user.privilege}"/>
            <p><h3>Bio</h3><c:out value="${user.bio}"/></p>
            <c:if test="${sessionScope['loginUser'] eq user.email}"><p>
                <button id="showupbio" onclick="document.getElementById('upbio').style.display='block'; document.getElementById('showupbio').style.display='none';">Edit bio</button>
                <form id="upbio" method="post" style="display:none;">
                    Edit bio<br/><textarea name="bio" id="bio">${user.bio}</textarea><br/>
                    <button type="button" onclick="document.getElementById('showupbio').style.display='block'; document.getElementById('upbio').style.display='none';">Cancel</button>
                    <input type="submit" value="Update"/>
                </form>
            </p></c:if>
        </div></c:forEach>
    </c:otherwise>
</c:choose>
<%@ include file="bottom.html" %>
