$(document).ready(function(){
  var run = document.getElementById('submit');
  run.addEventListener('click', showGraphs);
  var graph = document.getElementById('graph');
  graph.addEventListener('click', showChart);
});

var dataFuture;
var dataCurrent;
var dates;
function showGraphs() {
	$(".results").empty();
	$(".cityGraphs").empty();
	var costs;
	var deltas;
	var cities;
	if (document.getElementById("1").checked == true) {
		//NE
			costs = [0.148085714, 0.136342857, 0.139057143, 0.144, 0.141428571, 0.143714286, 0.147371429];
			deltas = [0.8495,0.8427,0.8443,0.8472,0.8457,0.847,0.8491];
			cities = ["Baltimore","Boston","New York","Philadelphia","Pittsburgh","Richmond","Washington"];
	}
	else if (document.getElementById("2").checked == true) {
		//South
			costs = [0.202,0.19932,0.20196,0.2004,0.19632];
			deltas = [0.8473,0.8462,0.8473,0.8467,0.845];
			cities = ["Las Vegas","Los Angeles","Salt Lake City","San Francisco","Seattle"];
	}
	else {
		//West
			costs = [0.19744,0.20212,0.19788,0.20088,0.20168];
			deltas = [0.8454,0.8474,0.8456,0.8469,0.8472];
			cities = ["Austin","Birmingham","Charlotte","Denver","Nashville"];
	}
	var tableResults = "<h4>Results</h4><p>";
	for (i = 0; i < cities.length; i++) {
		tableResults += cities[i]+": $" + costs[i]*document.getElementById("budget").value+ " for improved recovery rate of " + deltas[i]+"<br>";
	}
	tableResults += "</p>";
	var dropDown = "<h4>Graph the improvements for a given city</h4><select id = \"cities\">";
	for (i = 0; i < cities.length; i++) {
		dropDown += "<option value = '0'>"+cities[i]+"</option>"
	}
	dropDown += "</select><button id=\"graph\">Graph</button>";
	$(".results").append(tableResults);
	$(".cityGraphs").append(dropDown);
}
function showChart() {          
	console.log("here");
	var chart = "<canvas id = \"myChart\" width = \"900\" height = \"600\"></canvas> <div id = \"js-legend\" class = \"chart-legend\"></div>";
	var ctx = document.getElementById("myChart").getContext("2d");
	var city = document.getElementById("graph").value;
	var data = {
      labels: dates,
      datasets: 
      [{
        label: city+" Before",
        fillColor: fill,
        strokeColor: color,
        pointColor: color,
        pointStrokeColor: "#fff",
        pointHighlightFill: "#fff",
        pointHighlightStroke: "rgba(151,187,205, 1)",
        data: dataCurrent[city]
      },
      {
        label: city + " After",
        fillColor: fill,
        strokeColor: color,
        pointColor: color,
        pointStrokeColor: "#fff",
        pointHighlightFill: "#fff",
        pointHighlightStroke: "rgba(151,187,205, 1)",
        data: dataFuture[city]
      }]
    };
    var options = {
      legendTemplate: '<ul id = \"legend\"> <li><div class=\"box\" style=\"background-color:#FFF>\"></div>LEGEND</li>'
                  +'<% for (var i=0; i<datasets.length; i++) { %>'
                    +'<li>'
                    +'<div class=\"box\" style=\"background-color:<%=datasets[i].strokeColor%>\"></div>'
                    +'<% if (datasets[i].label) { %><%= datasets[i].label %><% } %>'
                  +'</li>'
                +'<% } %>'
              +'</ul>',
      pointDot : false,
    };
    var myLineChart = new Chart(ctx).Line(data, options);
    document.getElementById('js-legend').innerHTML = myLineChart.generateLegend();
}