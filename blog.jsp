<%@ include file="top.jsp" %>
        <title>BlogSec |
    <c:choose>
        <c:when test="${empty param.id}">
            Blog Posts
            <sql:query dataSource="jdbc/BSDB" var="result">
                SELECT post_id, title, first_name, last_name, modified FROM Posts NATURAL JOIN Users;
            </sql:query>
        </c:when>
        <c:otherwise>
            <sql:query dataSource="jdbc/BSDB" var="result">
                SELECT title, first_name, last_name, content, modified FROM Posts NATURAL JOIN Users WHERE post_id = ?;
                <sql:param value="${param.id}"/>
            </sql:query>
            <c:forEach var="r" items="${result.rows}"><c:out value="${r.title} by ${r.first_name} ${r.last_name}"/></c:forEach>
        </c:otherwise>
    </c:choose>
        </title>
    </head>
<%@ include file="nav.jsp" %>
<c:choose>
    <c:when test="${empty param.id}">
        <h1>Posts</h1><hr/>
        <table width="100%">
            <thead><tr>
                <th>Title</th>
                <th>By</th>
                <th>Modified</th>
            </tr></thead>
            <tbody>
                <c:forEach var="r" items="${result.rows}"><tr>
                    <td><a href="blog.jsp?id=<c:out value='${r.post_id}'/>"><c:out value="${r.title}"/></a></td>
                    <td><c:out value="${r.first_name} ${r.last_name}"/></td>
                    <td><c:out value="${r.modified}"/></td>
                </tr></c:forEach>
            </tbody>
        </table>
    </c:when>
    <c:otherwise><c:forEach var="r" items="${result.rows}">
        <div>
            <h1><c:out value="${r.title}"/></h1>
            <h3><c:out value="${r.first_name} ${r.last_name}"/></h3><hr/>
            <p><c:out value="${r.content}"/></p><!-- will support markdown eventually -->
            <p style="text-align:right;"><i>Modified <c:out value="${r.modified}"/></i></p>
            <hr/>
        </div>
        <sql:query dataSource="jdbc/BSDB" var="replies">
            SELECT first_name, last_name, content, modified FROM Replies NATURAL JOIN Users WHERE post_id = ?;
            <sql:param value="${param.id}"/>
        </sql:query>
        <c:forEach var="re" items="${replies.rows}"><div>
            <p><c:out value="${re.content}"/></p>
            <p style="text-align:right;"><i>- <c:out value="${re.first_name} ${re.last_name}, ${re.modified}"/></i></p>
        </div></c:forEach>
    </c:forEach></c:otherwise>
</c:choose>
<%@ include file="bottom.html" %>
