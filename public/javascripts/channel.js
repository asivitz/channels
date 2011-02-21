var waitMin = 5;
var waitMax = 45;
var waitReset = 10;
var waitTime = waitReset;

function waitForMsg(channelid)
{
    var newmsgs = getNewMessages(channelid);
    if (newmsgs)
    {
        waitTime -= 5;
        if (waitTime < waitMin)
            waitTime = waitMin;
        if (waitTime > waitReset)
            waitTime = waitReset;
    }
    else
    {
        waitTime += 5;
        if (waitTime > waitMax)
            waitTime = waitMax;
    }

    setTimeout('waitForMsg(' + channelid + ')', waitTime * 1000);
}

function getNewMessages(channelid)
{
    $.ajax(
        {
            url:"/channels/get_updates/" + channelid + "?last_read=" + currentnumber,
            cache: false,
            dataType: 'json',
            success: function(json)
            {
                for (var i = 0; i < json.length; i++)
                {
                    var msg = json[i];
                    addMessageToTable(msg['id'], msg['name'], msg['date'], msg['content']);
                }
            }
        }
        );
        return false;
}

function addMessageToTable(id, username, time, content)
{
    //see if we already have this message
    var existing = $('#message_' + id);
    if (existing.length > 0)
        return;

    //find the last poster. if the names are the same, don't show a new username
    var toprow = $('#messagetable tr').first();
    var last = jQuery.trim(toprow.children()[1].innerHTML);

    namedisplay = username + ":";
    var linehtml = '<li id="message_' + id + '">' + content + '</li>';

    var added = null;
    if (last == username + ":")
    {
        var line = $(linehtml);
        var ul = toprow.children().last().children().first();
        line.appendTo(ul);
        added = line;
    }
    else
    {
        var row = $('<tr id=\"message_' + id + '\"><td class=\"datecol\">' + time + '</td><td class=\"namecol\">' + namedisplay + '</td><td class=\"contentcol\"><ul>' + linehtml + '</ul></td></tr>');
        row.prependTo('#messagetable');
        added = row;
    }


    added[0].style.color = 'blue';
    added[0].style.opacity = 0;
    added.animate(
            { opacity:1, color:'black' },
           1000,
          null);
}
