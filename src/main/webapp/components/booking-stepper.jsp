<%-- booking-stepper.jsp
     Usage: <jsp:include page="/components/booking-stepper.jsp">
                <jsp:param name="step" value="3"/>
            </jsp:include>
     Steps: 1=Flight, 2=Travellers, 3=Seats, 4=Extras, 5=Review, 6=Payment
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    int step = 1;
    try { step = Integer.parseInt(request.getParameter("step")); } catch(Exception e){}
    String[] labels = {"Flight", "Travellers", "Seats", "Extras", "Review", "Payment"};
    String[] icons  = {"✈️",     "👤",          "💺",     "🎁",     "📋",     "💳"};
%>
<div style="
    background: rgba(255,255,255,0.02);
    border-bottom: 1px solid rgba(255,255,255,0.08);
    padding: 16px 0;
    margin-bottom: 8px;
">
    <div class="container" style="max-width:1100px; margin:0 auto; padding:0 20px;">
        <div style="display:flex; align-items:center; justify-content:center; gap:0;">
            <% for(int i=1; i<=6; i++) {
                boolean done    = i < step;
                boolean current = i == step;
                String circleStyle = done    ? "background:var(--color-primary);color:#000;border-color:var(--color-primary);"
                                   : current ? "background:rgba(212,165,116,0.15);color:var(--color-primary);border-color:var(--color-primary);"
                                   :           "background:transparent;color:rgba(255,255,255,0.25);border-color:rgba(255,255,255,0.12);";
                String labelStyle  = done || current ? "color:var(--color-primary);" : "color:rgba(255,255,255,0.25);";
            %>
                <!-- Step Circle -->
                <div style="display:flex;flex-direction:column;align-items:center;gap:6px;min-width:70px;">
                    <div style="
                        width:36px;height:36px;border-radius:50%;
                        border:2px solid; display:flex;align-items:center;justify-content:center;
                        font-size:0.95rem;font-weight:800;transition:all .3s;
                        <%=circleStyle%>
                    ">
                        <% if(done){ %> ✓ <% } else { %> <%=icons[i-1]%> <% } %>
                    </div>
                    <span style="font-size:0.72rem;font-weight:<%=current?"700":"500"%>;white-space:nowrap;<%=labelStyle%>">
                        <%=labels[i-1]%>
                    </span>
                </div>
                <!-- Connector line (except after last) -->
                <% if(i<6){ %>
                <div style="flex:1;height:2px;margin-bottom:22px;
                    background:<%=done?"var(--color-primary)":"rgba(255,255,255,0.08)"%>;
                    max-width:60px;transition:background .3s;">
                </div>
                <% } %>
            <% } %>
        </div>
    </div>
</div>
