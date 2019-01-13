var margin = {top: 30, right: 30, bottom: 30, left: 70},
    width = 700 - margin.left - margin.right,
    height = 400 - margin.top - margin.bottom;

var parseDate = d3.time.format("%Y-%m-%d").parse;

var x = d3.time.scale().range([0, width]);
var y0 = d3.scale.linear().range([height, 0]);
var y1 = d3.scale.linear().range([height, 0]);

var xAxis = d3.svg.axis().scale(x)
    .orient("bottom")
    .ticks(5)
    .tickFormat(d3.time.format("%Y"));

var yAxisLeft = d3.svg.axis().scale(y0)
    .orient("left")
    .ticks(5);

var yAxisRight = d3.svg.axis().scale(y1)
    .orient("right")
    .ticks(5); 

var valueline = d3.svg.line()
    .x(function(d) { return x(d.year); })
    .y(function(d) { return y0(d.gdp); });
    
var valueline2 = d3.svg.line()
    .x(function(d) { return x(d.year); })
    .y(function(d) { return y1(d.co2); });
  
var svg = d3.select("body")
    .append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
    .append("g")
        .attr("transform", 
              "translate(" + margin.left + "," + margin.top + ")");

// Get the data
d3.csv("ghg-gdp-ca.csv", function(error, data) {
    data.forEach(function(d) {
        d.year = parseDate(d.year);
        d.gdp = +d.gdp;
        d.co2 = +d.co2;
    });

    // Scale the range of the data
    x.domain(d3.extent(data, function(d) { return d.year; }));
    y0.domain([0, d3.max(data, function(d) {
        return Math.max(d.gdp); })]); 
    y1.domain([0, d3.max(data, function(d) { 
        return Math.max(d.co2); })]);

    svg.append("path")        // Add the valueline path.
        .attr("d", valueline(data));

    svg.append("path")        // Add the valueline2 path.
        .style("stroke", "red")
        .attr("d", valueline2(data));

    svg.append("g")            // Add the X Axis
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis);

    svg.append("g")
        .attr("class", "y axis")
        .style("fill", "steelblue")
        .call(yAxisLeft);   

    svg.append("text")       // left y axis label
      .attr("transform", "rotate(-90)")
      .attr("y", 0 - margin.left)
      .attr("x",0 - (height / 2))
      .attr("dy", "1em")
      .style("text-anchor", "middle")
      .style("fill", "steelblue")
      .text("GDP per Capita");  

    svg.append("g")             
        .attr("class", "y axis")    
        .attr("transform", "translate(" + width + " ,0)")   
        .style("fill", "red")       
        .call(yAxisRight);

    svg.append("text")       // right y axis label
      .attr("transform", "rotate(-90)")
      .attr("y", margin.right)
      .attr("x", 0 - (height / 2))
      .attr("dy", "47em")
      .style("text-anchor", "middle")
      .style("fill", "red")
      .text("Carbon Dioxide Emissions");  

});