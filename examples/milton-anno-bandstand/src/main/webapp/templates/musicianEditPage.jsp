<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <%@include file="/templates/includes/theme-top.jsp" %>
    </head>

    <body>

        <div class="navbar navbar-inverse navbar-fixed-top">
            <div class="navbar-inner">
                <div class="container">
                    <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="brand" href="#">BandStand</a>
                    <div class="nav-collapse collapse">
                        <ul class="nav">
                            <li class="active"><a href="#">Home</a></li>
                            <li><a href="#about">About</a></li>
                            <li><a href="#contact">Contact</a></li>
                        </ul>
                    </div><!--/.nav-collapse -->
                </div>
            </div>
        </div>

        <div class="container">
            <form class="form-horizontal" method="POST" action="${module.page.name}" class="editMusician">
                <fieldset>
                    <legend>Edit musician details</legend>
                    <div class="control-group">
                        <label class="control-label" >Muso name</label>
                        <div class="controls">
                            <input id="name" required="" type="text" name="name" value="${model.page.source.name}"/>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" >Description</label>
                        <div class="controls">
                            <textarea id="description" name="description">${model.page.source.description}</textarea>
                        </div>
                    </div>
                    <div class="control-group">
                        <div class="controls">
                            <button type="submit" class="btn"><i class="icon-ok-sign"></i> Save</button>
                        </div>
                    </div>                            
                </fieldset>
            </form>
        </div> <!-- /container -->

        <%@include file="includes/theme-bottom.jsp" %>

        <script type="text/javascript">
            $(function() {
                $("input,select,textarea").not("[type=submit]").jqBootstrapValidation({
                    submitSuccess: function(form, e) {
                        e.stopPropagation();
                        e.cancel=true;
                        e.preventDefault();
                        
                        postForm(form);
                        
                        return false;
                    }
                });
            });
            
            function postForm(form) {
                var serialised = form.serialize();
                form.trigger("preSubmitForm", serialised);
                try {                    
                    $.ajax({
                        type: 'POST',
                        url: form.attr("action"),
                        data: serialised,
                        dataType: "json",
                        success: function(resp) {
                            ajaxLoadingOff();                            
                            if( resp && resp.status) {
                                log("save success", resp)
                                callback(resp, form)
                            } else {
                                log("status indicates failure", resp)
                                try {                                    
                                    var messagesContainer = form;
                                    if( resp.messages && resp.messages.length > 0 ) {
                                        for( i=0; i<resp.messages.length; i++) {
                                            var msg = resp.messages[i];
                                            messagesContainer.append("<p>" + msg + "</p>");
                                        }
                                    } else {
                                        messagesContainer.append("<p>Sorry, we couldnt process your request</p>");
                                    }
                                    messagesContainer.show(100);
                                    showFieldMessages(resp.fieldMessages, form)
                                } catch(e) {
                                    log("ex", e);
                                }
                                alert("Sorry, an error occured and the form could not be processed. Please check for validation messages");
                            }                            
                        },
                        error: function(resp) {
                            ajaxLoadingOff();
                            log("error posting form", form, resp);
                            alert("err " + resp);
                        }
                    });                
                } catch(e) {
                    log("exception sending forum comment", e);
                }      
            }
            
        </script>
    </body>
</html>
