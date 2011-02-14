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
            url:"/channels/get_updates/" + channelid,
            cache: false,
            success: function(data)
            {
                var json = eval('(' + data + ')');
                var nummsgs = json['number'];
                if (nummsgs > currentnumber)
                {
                    for (var i = currentnumber; i < nummsgs; i++)
                    {
                        retrieveMessage(channelid, i);
                    }

                    currentnumber = nummsgs;
                    return true;
                }
                else
                {
                    return false;
                }
            }
        }
        );
        return false;
}

function retrieveMessage(channelid, messagenum)
{
    $.ajax(
    {
        url:"/channels/get_message/" + channelid + "?messagenum=" + messagenum,
        cache: false,
        success: function(data)
        {
            var json = eval('(' + data + ')');
            addMessageToTable(json['name'],json['date'],json['content']);
        },
        error: function(XMLHttpRequest, textStatus, errorThrown)
        {
            alert("error getting message: " + textStatus + " (" + errorThrown + ")");
        }
    }
    );
}

function addMessageToTable(username, time, content)
{
    var row = $('<tr><td class=\"datecol\">' + time + '</td><td class=\"namecol\">' + username + ':</td><td class=\"contentcol\">' + content + '</td></tr>');
    row.prependTo('#messagetable')

    row[0].style.color = 'blue';
    row[0].style.opacity = 0;
    row.animate(
            { opacity:1, color:'black' },
           1000,
          null);
}
