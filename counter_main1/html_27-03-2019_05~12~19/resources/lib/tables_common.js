var url = "resources/report/empty.json";
var isSupportLocalFile = true;
$.ajax({
    type: "GET",
    url: url,
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    beforeSend: function (xhr) {
        //if (checkLoginBeforeRequestExpired()){xhr.abort()};
        //xhr.setRequestHeader("Authorization", getAuthXToken());
    },
    success: function (data) {


    },
    error: function (jqXHR) {

        alert("Your Chrome browser" +
            " blocks the report from reading data files.\nPlease stop all chrome processes and launch the Google Chrome browser from the command line window with the additional argument: \n'-allow-file-access-from-files'.\nE.g path to your chrome installation\chrome.exe --allow-file-access-from-files");
        isSupportLocalFile = false;

    },
    complete: function () {

    }

});


$(document).ready(function () {

    var colorCheckbox = document.getElementById('colorSet');
    if (colorCheckbox != null && colorCheckbox != undefined) {
        colorCheckbox.checked = isRegularColor;
    } else {
        isRegularColor = true;
    }
    try {
        if (myLayout != null && myLayout != undefined) {
            myLayout.sizePane("north", 200);
        }
    } catch (e) {

    }
});


var isRegularColor = $.cookie("colorSet") === "false" ? false : true;

function hideAll() {
    for (var i = 1; i < 6; ++i) {

        hideObj(document.getElementById('table' + i));
        hideObj(document.getElementById('filter' + i + '_div'));
    }

}

function hideObj(obj) {
    if (obj == null || obj == undefined) {
        return;
    }
    obj.style.visibility = 'hidden';
}


function changeColor() {
    // Check if the checkbox is checked
    var colorCheckbox = document.getElementById('colorSet');
    isRegularColor = colorCheckbox.checked ? true : false;
    $.cookie("colorSet", isRegularColor);
    initUI(true);

};

function checkColor() {

    document.getElementById('colorSet').checked = isRegularColor;
}

function getColor(gr) {

    return isRegularColor ? getRegularColors(gr) : getColorsBlind(gr);
}

function getRegularColors(gr) {
    var bgcolor = "#cccccc";
    if (gr == 0) bgcolor = "#ff6666";
    else if (gr < 29) bgcolor = "#ff9999";
    else if (gr < 50) bgcolor = "#ffcc99";
    else if (gr < 75) bgcolor = "#ffff66";
    else if (gr < 100) bgcolor = "#99ff66";
    else if (gr == 100) bgcolor = "#33cc00";
    return bgcolor;
}

function getColorsBlind(gr) {
    var bgcolor = "#f4f4f4";
    if (gr == 0) bgcolor = "#f4f4f4";
    else if (gr < 29) bgcolor = "#ffe800";
    else if (gr < 50) bgcolor = "#ffe800";
    else if (gr < 75) bgcolor = "#ffe800";
    else if (gr < 100) bgcolor = "#ffcccc";
    else if (gr == 100) bgcolor = "#3d6ab3";
    return bgcolor;
}

function getFontColor(gr) {
    var color = "#000000";
    if (gr == 0) color = "#000000";
    else if (gr < 29) color = "#3d6ab3";
    else if (gr < 50) color = "#3d6ab3";
    else if (gr < 75) color = "#3d6ab3";
    else if (gr < 100) color = "#000000";
    else if (gr == 100) color = "#ffe800";
    return color;
}


function getCell(event, data, name_column_number, isTermStr) {
    var node = data.node,
        $tdList = $(node.tr).find(">td"),
        cell,
        count = 0;
    var isExcluded = (data.node.data.excluded === "1");

    for (cell in data.node.data) {


        if (count == name_column_number) {    // 2 column is title!!
            $tdList.eq(count)[0].style.overflow = "hidden";
            $tdList.eq(count)[0].title = data.node.title;
            if (isExcluded) {
                $tdList.eq(count)[0].style.color = "#808080";
            }
            if (isTermStr === true) {
                $tdList.eq(count).html(getTableFromStrs(data.node.title.split(";")));
            }
            ++count;
        }

        if (isExcluded && isRegularColor && $tdList.eq(count)[0] != null && $tdList.eq(count)[0] != undefined) {
            $tdList.eq(count)[0].style.color = "#808080";

        }
        var val = data.node.data[cell];
        if (cell.toLowerCase().indexOf("grd") >= 0 || cell.toLowerCase().indexOf("cov") >= 0 || cell.toLowerCase().indexOf("grad") >= 0 || cell.toLowerCase().indexOf("(rank)") >= 0) {
            var numValue;
            if (val == null) {
                numValue = 0;
            } else {
                numValue = val.replace(/%/gi, ''); //remove %

                var indx = numValue.indexOf('(');
                if (indx > 0) {
                    numValue = numValue.substr(indx + 1, (numValue.indexOf(')') - indx - 1));
                }
            }
            if ($tdList.eq(count)[0] != null && $tdList.eq(count)[0] != undefined) {
                $tdList.eq(count)[0].style.backgroundColor = isExcluded ? "#cccccc" : getColor(numValue);
                if (!isRegularColor && !isExcluded) {
                    $tdList.eq(count)[0].style.color = getFontColor(numValue);
                }
            }
        } else if (cell.toLowerCase().indexOf("score") >= 0) {
            if (isExcluded) {
                if ($tdList.eq(count)[0] != null && $tdList.eq(count)[0] != undefined) {
                    $tdList.eq(count)[0].style.backgroundColor = "#cccccc";
                }

            } else {

                var numValue = (val == null) ? 0 : parseInt(val, 10);
                if ($tdList.eq(count)[0] != null && $tdList.eq(count)[0] != undefined) {
                    $tdList.eq(count)[0].style.backgroundColor = (val === 'X') ? "#cccccc" : getColor(numValue === 0 ? 0 : 100);
                    if (!isRegularColor) {
                        $tdList.eq(count)[0].style.color = (val === 'X') ? "#000000" : getFontColor(numValue === 0 ? 0 : 100);
                    }
                }
            }

        } else if (cell.toLowerCase().indexOf("status") >= 0) {
            if ($tdList.eq(count)[0] != null && $tdList.eq(count)[0] != undefined) {
                $tdList.eq(count)[0].style.backgroundColor = (val === 'passed') ? getColor(100) : (val === 'failed') ? getColor(0) : getColor(50);
            }

        }

        if (val == "-1.0") {
            val = "n/a";
        }

        if (val.toLowerCase() == "none") {
            val = "";
        }
        $tdList.eq(count).html(val);
        ++count;
    }
}

function getTableFromStrs(ls) {

    if (ls.length == 0) {
        return "";
    }
    var w = 100 / ls.length;
    var res = [];
    res[res.length] = "<div width=100%><table width=100%><tr width=100%>";
    var isLong = (ls.length > 5);
    for (var i = 0; i < ls.length; ++i) {
        var s = ls[i];
        if (isLong && s.length > 11) {
            s = s.substr(0, 11) + "...";
        }
        res[res.length] = "<td width=" + w + "%  align=center title='" + ls[i] + "' >" + s + "</td>";

    }
    res[res.length] = "</tr></table></div>";

    return res.join("");
}


//filter
function implementFilter(inputObj, resetBtn, matchesLayer, treeTable) {
    inputObj.keyup(function (e) {
        if (e && e.which != $.ui.keyCode.ENTER) {
            return;
        }
        var n,

            match = $(this).val();

        if (e && e.which === $.ui.keyCode.ESCAPE || $.trim(match) === "") {
            resetBtn.click();
            return;
        }

        // Pass a string to perform case insensitive matching
        n = treeTable.filterNodes(match, false);

        resetBtn.attr("disabled", false);
        matchesLayer.text("(" + n + " matches)");
    }).focus();


    //reset filter
    resetBtn.click(function (e) {
        inputObj.val("");
        matchesLayer.text("");
        treeTable.clearFilter();
    }).attr("disabled", true);

}

