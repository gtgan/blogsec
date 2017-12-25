<%@ include file="top.jsp" %>
        <title>BlogSec | Hack This Page</title>
    </head>
<%@ include file="nav.jsp" %>
        <h1>Hack This Page</h1><hr/>
        This is a hackable page. If you're logged in, you can type into a field with no input validation.
    <c:if test="${userPrivilege == 'true'}">
        <c:if test="${not empty param.in && userPrivilege == 'true'}">
            <sql:update dataSource="jdbc/bloghax" var="r">
                INSERT INTO Vulnerable (email, value) VALUES ('${sessionScope['loginUser']}', '${param.in}');
            </sql:update>
        </c:if>
        <form>
            <textarea name="in" placeholder="Vulnerable input" style="width:100%;min-height:64px"></textarea>
            <br/><input type="submit" value="Submit"/>
        </form>
    </c:if>
        <hr/>
    <sql:query dataSource="jdbc/bloghax" var="result">
        SELECT value, first_name, last_name, modified FROM Vulnerable NATURAL JOIN Users;
    </sql:query>
    <c:forEach var="r" items="${result.rows}">
        <p>${r.value}</p>
        <p style="text-align:right;"><i>- ${r.first_name} ${r.last_name}, ${r.modified}</i></p>
    </c:forEach>
<%@ include file="bottom.html" %>
