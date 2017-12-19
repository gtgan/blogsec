<%@ include file="top.jsp" %>
        <title>BlogSec |
    <c:choose>
        <c:when test="${empty param.id}">
            Blog Posts
            <sql:query dataSource="jdbc/blogsec" var="result">
                SELECT post_id, title, first_name, last_name, modified FROM Posts NATURAL JOIN Users ORDER BY created DESC;
            </sql:query>
        </c:when>
        <c:otherwise>
            <sql:query dataSource="jdbc/blogsec" var="result">
                SELECT title, email, first_name, last_name, content, modified FROM Posts NATURAL JOIN Users WHERE post_id = ?;
                <sql:param value="${param.id}"/>
            </sql:query>
            <c:forEach var="r" items="${result.rows}"><c:out value="${r.title} by ${r.first_name} ${r.last_name}"/></c:forEach>
        </c:otherwise>
    </c:choose>
        </title>
    </head>
<%@ include file="nav.jsp" %>
<%@ include file="privilege.jsp" %>
<c:choose>
    <c:when test="${empty param.id}">
        <h1>Posts</h1><hr/>
        <c:if test="${privilege eq 'admin' || privilege eq 'user'}">
        <a href="newpost.jsp">New post</a>
        </c:if>
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
            <p style="text-align:right;">
                <c:if test="${r.email eq sessionScope['loginUser'] || privilege eq 'admin'}">
                    <form name="delete" method="post">
                        <!-- edit/delete -->
                    </form>
                </c:if>
                <i>Modified <c:out value="${r.modified}"/></i>
            </p>
            <hr/>
            <c:if test="${userPrivilege eq 'true'}">
                <c:if test="${not empty param.replyText}">
                    <sql:update dataSource="jdbc/blogsec" var="res">
                        INSERT INTO Replies (email, post_id, content) VALUES (?, ?, ?);
                        <sql:param value="${sessionScope['loginUser']}"/>
                        <sql:param value="${param.id}"/>
                        <sql:param value="${param.replyText}"/>
                    </sql:update>
                </c:if>
            <form id="replyForm" method="post">
                <input name="replyText" type="text" placeholder="Reply"></textarea>
                <input type="submit" value="Reply"/>
            </form>
            </c:if>
        </div>
        <sql:query dataSource="jdbc/blogsec" var="replies">
            SELECT first_name, last_name, content, modified FROM Replies NATURAL JOIN Users WHERE post_id = ? ORDER BY created;
            <sql:param value="${param.id}"/>
        </sql:query>
        <c:forEach var="re" items="${replies.rows}"><div>
            <p><c:out value="${re.content}"/></p>
            <p style="text-align:right;"><i>- <c:out value="${re.first_name} ${re.last_name}, ${re.modified}"/></i></p>
        </div></c:forEach>
    </c:forEach></c:otherwise>
</c:choose>
<%@ include file="bottom.html" %>
