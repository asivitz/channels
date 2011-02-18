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
    var names = jQuery.trim($('#messagetable tr td.namecol').text()).split(/\s+/);
    var last = names[names.length - 1];

    namedisplay = username + ":";
    if (last == username + ":")
        namedisplay = "";

    //make the row
    var row = $('<tr id=\"message_' + id + '\"><td class=\"datecol\">' + time + '</td><td class=\"namecol\">' + namedisplay + '</td><td class=\"contentcol\">' + content + '</td></tr>');
    row.appendTo('#messagetable')

    row[0].style.color = 'blue';
    row[0].style.opacity = 0;
    row.animate(
            { opacity:1, color:'black' },
           1000,
          null);
}
