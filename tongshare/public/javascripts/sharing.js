function add_members(data)
{
    clear_errors();

    list = $('new_members');
    for(var i = 0; i < data.valid.size(); i++)
    {       
        item = data.valid[i];

        if($('new_member_' + item.id) != null)
        {
            $('new_member_' + item.id).remove();
        }

        li = new Element("li", {
            "id": "new_member_" + item.id
            });

        li.insert("<a href=\"javascript: del_member(" + item.id + ")\" class=\"del\">\u2717</a>");
        li.insert("&nbsp;&nbsp;<span class=\"name\">" + item.name + "</span>");
        li.insert("<input type=\"hidden\" name=\"members[]\" value=\"" + item.id + "\">");

        //conflict
        if(item.conflict.size() > 0)
        {
            li.insert("&nbsp;&nbsp;<a href=\"javascript: toggle_conflict(" + item.id + ")\" class=\"conflict_link\">" +
                I18n.t('tongshare.sharing.conflict.link') +
                "</a>");

            conflict_div = new Element("div", {"id": "conflict_" + item.id, "class": "conflict", "style": "display:none"});
            conflict_div.insert(I18n.t('tongshare.sharing.conflict.prompt'));

            conflict_list = new Element("ul");
            for(var ci = 0; ci < item.conflict.size(); ci++)
            {
                conflict_list.insert('<li>' + item.conflict[ci] + '</li>');
            }
            conflict_div.insert(conflict_list);

            if(data.recurring)
            {
                conflict_div.insert(I18n.t('tongshare.sharing.conflict.about_repeat') + "<br/>");
            }
            
            conflict_div.insert('<a href="' + data.edit_event_path + '" target="_blank">' +
                    I18n.t('tongshare.sharing.conflict.edit_event') +
                    '</a>');

            li.insert(conflict_div);
        }

        list.insert(li);
    }

    if(data.dummy != null && data.dummy.size() > 0)
    {
        $('new_dummy_container').show();
        list = $('new_dummy');
        for(i = 0; i < data.dummy.size(); i++)
        {
            item = data.dummy[i];

            if($('new_dummy_' + item) != null)
            {
                continue;
            }

            li = new Element("li", {
                "id": "new_dummy_" + item
                });

            li.insert("<a href=\"javascript: del_dummy(" + item + ")\" class=\"del\">\u2717</a>");
            li.insert("&nbsp;&nbsp;<span class=\"name\">" + item + "</span>");
            li.insert("<input type=\"hidden\" name=\"dummy[]\" value=\"" + item + "\">");
            list.insert(li);
        }
    }

    if(data.new_email != null && data.new_email.size() > 0)
    {
        $('new_email_container').show();
        list = $('new_email');
        for(i = 0; i < data.new_email.size(); i++)
        {
            item = data.new_email[i];

            if($('new_email_' + item) != null)
            {
                continue;
            }

            li = new Element("li", {
                "id": "new_email_" + item
                });

            li.insert("<a href=\"javascript: del_new_email('" + item + "')\" class=\"del\">\u2717</a>");
            li.insert("&nbsp;&nbsp;<span class=\"name\">" + item + "</span>");
            li.insert("<input type=\"hidden\" name=\"new_email[]\" value=\"" + item + "\">");
            list.insert(li);
        }
    }

    show_errors("invalid", data.invalid);
    show_errors("duplicated", data.duplicated);
    show_errors("parse_errored", data.parse_errored);

    toggle_nil_prompt();
}

function show_errors(type, data)
{
    if(data != null && data.size() > 0)
    {
        $("errors_" + type + "_container").show();
        list = $("errors_" + type);
        for(var i = 0; i < data.size(); i++)
        {
            list.insert("<li>" + data[i] + "</li>");
        }
    }
}

function clear_errors()
{
    $("errors_invalid_container").hide();
    $("errors_duplicated_container").hide();
    $("errors_parse_errored_container").hide();
    $("errors_invalid").innerHTML = "";
    $("errors_duplicated").innerHTML = "";
    $("errors_parse_errored").innerHTML = "";
}

function del_member(id)
{
    item = $('new_member_' + id);
    item.remove();
    toggle_nil_prompt();
}

function del_dummy(name)
{
    item = $('new_dummy_' + name);
    item.remove();
    if($('new_dummy').empty())
    {
        $('new_dummy_container').hide();
    }
    toggle_nil_prompt();
}

function del_new_email(email)
{
    item = $('new_email_' + email);
    item.remove();
    if($('new_email').empty())
    {
        $('new_email_container').hide();
    }
    toggle_nil_prompt();
}

function toggle_nil_prompt()
{
    if($('new_dummy').empty() && $('new_members').empty())
    {
        $('new_member_nil').show();
    }
    else
    {
        $('new_member_nil').hide();
    }
}

function checkFormValid(form)
{
    if (form.getInputs('hidden','members[]').size() == 0 && form.getInputs('hidden', 'dummy[]').size() == 0 && form.getInputs('hidden', 'new_email[]').size() == 0)
    {
        alert(I18n.t('tongshare.sharing.empty'));
        return false;
    }
    else
    {
        return true;
    }
}

function toggle_conflict(id)
{
    Effect.toggle('conflict_' + id, 'slide', {duration: 0.5});
}