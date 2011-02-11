var waitMin = 5;
var waitMax = 45;
var waitReset = 20;
var waitTime = waitReset;

function waitForMsg(channelid)
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
            },
            error: function(XMLHttpRequest, textStatus, errorThrown)
            {
                alert("error: " + textStatus + " (" + errorThrown + ")"); 
                //setTimeout('waitForMsg()', 15000);
            }
        }
        );
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
    row = '<tr><td>' + username + '</td><td>' + time + '</td><td>' + content + '</td></tr>';
    $(row).appendTo('#messagetable');
}
