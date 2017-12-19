<c:set var="privilege" value=""/>
<c:if test="${not empty sessionScope['loginUser']}">
    <sql:query dataSource="jdbc/blogsec" var="priv">
        SELECT privilege FROM users WHERE email = ?;
        <sql:param value="${sessionScope['loginUser']}"/>
    </sql:query>
    <c:if test="${not empty priv}">
        <c:set var="privilege" value="${priv.rows[0].privilege}"/>
    </c:if>
</c:if>
<c:set var="userPrivilege" value="${privilege eq 'user' || privilege eq 'admin'}"/>
