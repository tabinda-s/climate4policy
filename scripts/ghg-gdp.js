var margin = {top: 20, right: 200, bottom: 100, left: 50},
    margin2 = { top: 430, right: 10, bottom: 20, left: 40 },
    width = 960 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom,
    height2 = 500 - margin2.top - margin2.bottom;

var parseDate = d3.time.format("%Y%m%d").parse;
var bisectDate = d3.bisector(function(d) { return d.year; }).left;

var xScale = d3.time.scale()
    .range([0, width]);

   // xScale2 = d3.time.scale()
    //.range([0, width]); // Duplicate xScale for brushing ref later

var yScale = d3.scale.linear()
    .range([height, 0]);

var yScaleRight = d3.scale.linear()
    .range([height, 0]);


// 40 Custom DDV colors 
var color = d3.scale.ordinal().range(["#48A36D",  "#e60000",  "#64B98C", "#72C39B", "#80CEAA", "#80CCB3", "#7FC9BD", "#7FC7C6", "#7EC4CF", "#7FBBCF", "#7FB1CF", "#80A8CE", "#809ECE", "#8897CE", "#8F90CD", "#9788CD", "#9E81CC", "#AA81C5", "#B681BE", "#C280B7", "#CE80B0", "#D3779F", "#D76D8F", "#DC647E", "#E05A6D", "#E16167", "#E26962", "#E2705C", "#E37756", "#E38457", "#E39158", "#E29D58", "#4785b8", "#E0B15B", "#DFB95C", "#DDC05E", "#DBC75F", "#E3CF6D", "#EAD67C", "#F2DE8A"]);  


var xAxis = d3.svg.axis()
    .scale(xScale)
    .orient("bottom");   

var yAxis = d3.svg.axis()
    .scale(yScale)
    .orient("left");  


var yAxisRight = d3.svg.axis()
    .scale(yScaleRight)
    .orient("right"); 

var line = d3.svg.line()
    .interpolate("basis")
    .x(function(d) { return xScale(d.date); })
    .y(function(d) { return yScale(d.rating); })
    .defined(function(d) { return d.rating; });  // Hiding line value defaults of 0 for missing data

//add new line for right axis
var lineRight = d3.svg.line()
    .interpolate("basis")
    .x(function(d) { return xScale(d.date); })
    .y(function(d) { return yScaleRight(d.rating); })
    .defined(function(d) { return d.rating; }); 

var maxY; // Defined later to update yAxis

var svg = d3.select("#ghg-gdp-area").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom) //height + margin.top + margin.bottom
  .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

//define state groups
var groups = {"co2-CA": "California",
              "gdp-CA": "California",
              "co2-US": "United States",
              "gdp-US": "United States",
              "co2-AL": "Alabama",
              "gdp-AL": "Alabama",
              "co2-AK": "Alaska",
              "gdp-AK": "Alaska",
              "co2-AZ": "Arizona",
              "gdp-AZ": "Arizona",
              "co2-AR": "Arkansas",
              "gdp-AR": "Arkansas",
              "co2-CO": "Colorado",
              "gdp-CO": "Colorado",
              "co2-CT": "Connecticut",
              "gdp-CT": "Connecticut",
              "co2-DE": "Delaware",
              "gdp-DE": "Delaware",
              "co2-DC": "District of Columbia",
              "gdp-DC": "District of Columbia",
              "co2-FL": "Florida",
              "gdp-FL": "Florida",
              "co2-GA": "Georgia",
              "gdp-GA": "Georgia",
              "co2-HI": "Hawaii",
              "gdp-HI": "Hawaii",
              "co2-ID": "Idaho",
              "gdp-ID": "Idaho",
              "co2-IL": "Illinois",
              "gdp-IL": "Illinois",
              "co2-IN": "Indiana",
              "gdp-IN": "Indiana",
              "co2-IA": "Iowa",
              "gdp-IA": "Iowa",
              "co2-KS": "Kansas",
              "gdp-KS": "Kansas",
              "co2-KY": "Kentucky",
              "gdp-KY": "Kentucky",
              "co2-LA": "Louisiana",
              "gdp-LA": "Louisiana",
              "co2-ME": "Maine",
              "gdp-ME": "Maine",
              "co2-MD": "Maryland",
              "gdp-MD": "Maryland",
              "co2-MA": "Massachusetts",
              "gdp-MA": "Massachusetts",
              "co2-MI": "Michigan",
              "gdp-MI": "Michigan",
              "co2-MN": "Minnesota",
              "gdp-MN": "Minnesota",
              "co2-MS": "Mississippi",
              "gdp-MS": "Mississippi",
              "co2-MO": "Missouri",
              "gdp-MO": "Missouri",
              "co2-MT": "Montana",
              "gdp-MT": "Montana",
              "co2-NE": "Nebraska",
              "gdp-NE": "Nebraska",
              "co2-NV": "Nevada",
              "gdp-NV": "Nevada",
              "co2-NH": "New Hampshire",
              "gdp-NH": "New Hampshire",
              "co2-NJ": "New Jersey",
              "gdp-NJ": "New Jersey",
              "co2-NM": "New Mexico",
              "gdp-NM": "New Mexico",
              "co2-NY": "New York",
              "gdp-NY": "New York",
              "co2-NC": "North Carolina",
              "gdp-NC": "North Carolina",
              "co2-ND": "North Dakota",
              "gdp-ND": "North Dakota",
              "co2-OH": "Ohio",
              "gdp-OH": "Ohio",
              "co2-OK": "Oklahoma",
              "gdp-OK": "Oklahoma",
              "co2-OR": "Oregon",
              "gdp-OR": "Oregon",
              "co2-PA": "Pennsylvania",
              "gdp-PA": "Pennsylvania",
              "co2-RI": "Rhode Island",
              "gdp-RI": "Rhode Island",
              "co2-SC": "South Carolina",
              "gdp-SC": "South Carolina",
              "co2-SD": "South Dakota",
              "gdp-SD": "South Dakota",
              "co2-TN": "Tennessee",
              "gdp-TN": "Tennessee",
              "co2-TX": "Texas",
              "gdp-TX": "Texas",
              "co2-UT": "Utah",
              "gdp-UT": "Utah",
              "co2-VT": "Vermont",
              "gdp-VT": "Vermont",
              "co2-VA": "Virginia",
              "gdp-VA": "Virginia",
              "co2-WA": "Washington",
              "gdp-WA": "Washington",
              "co2-WV": "West Virginia",
              "gdp-WV": "West Virginia",
              "co2-WI": "Wisconsin",
              "gdp-WI": "Wisconsin",
              "co2-WY": "Wyoming",
              "gdp-WY": "Wyoming"}

var groupsState ={"California": ["co2-CA", "gdp-CA"],
                  "United States": ["co2-US", "gdp-US"],
                  "Alabama": ["co2-AL", "gdp-AL"],
                  "Alaska": ["co2-AK", "gdp-AK"],
                  "Arizona": ["co2-AZ", "gdp-AZ"],
                  "Arkansas": ["co2-AR", "gdp-AR"],
                  "Colorado": ["co2-CO", "gdp-CO"],
                  "Connecticut": ["co2-CT", "gdp-CT"],
                  "Delaware": ["co2-DE", "gdp-DE"],
                  "District of Columbia": ["co2-DC", "gdp-DC"],
                  "Florida": ["co2-FL", "dp-FL"],
                  "Georgia": ["co2-GA", "gdp-GA"],
                  "Hawaii": ["co2-HI", "gdp-HI"],
                  "Idaho": ["co2-ID", "gdp-ID"],
                  "Illinois": ["co2-IL", "gdp-IL"],
                  "Indiana": ["co2-IN", "gdp-IN"],
                  "Iowa": ["co2-IA", "gdp-IA"],
                  "Kansas": ["co2-KS", "gdp-KS"],
                  "Kentucky": ["co2-KY", "gdp-KY"],
                  "Louisiana": ["co2-LA", "gdp-LA"],
                  "Maine": ["co2-ME", "gdp-ME"],
                  "Maryland": ["co2-MD", "gdp-MD"],
                  "Massachusetts": ["co2-MA", "gdp-MA"],
                  "Michigan": ["co2-MI", "gdp-MI"],
                  "Minnesota": ["co2-MN", "gdp-MN"],
                  "Mississippi": ["co2-MS", "gdp-MS"],
                  "Missouri": ["co2-MO", "gdp-MO"],
                  "Montana": ["co2-MT", "gdp-MT"],
                  "Nebraska": ["co2-NE", "gdp-NE"],
                  "Nevada": ["co2-NV", "gdp-NV"],
                  "New Hampshire": ["co2-NH", "gdp-NH"],
                  "New Jersey": ["co2-NJ", "gdp-NJ"],
                  "New Mexico": ["co2-NM", "gdp-NM"],
                  "New York": ["co2-NY", "gdp-NY"],
                  "North Carolina": ["co2-NC", "gdp-NC"],
                  "North Dakota": ["co2-ND", "gdp-ND"],
                  "Ohio": ["co2-OH", "gdp-OH"],
                  "Oklahoma": ["co2-OK", "gdp-OK"],
                  "Oregon": ["co2-OR", "gdp-OR"],
                  "Pennsylvania": ["co2-PA", "gdp-PA"],
                  "Rhode Island": ["co2-RI", "gdp-RI"],
                  "South Carolina": ["co2-SC", "gdp-SC"],
                  "South Dakota": ["co2-SD", "gdp-SD"],
                  "Tennessee": ["co2-TN", "gdp-TN"],
                  "Texas": ["co2-TX", "gdp-TX"],
                  "Utah": ["co2-UT", "gdp-UT"],
                  "Vermont": ["co2-VT", "gdp-VT"],
                  "Virginia": ["co2-VA", "gdp-VA"],
                  "Washington": ["co2-WA", "gdp-WA"],
                  "West Virginia": ["co2-WV", "gdp-WV"],
                  "Wisconsin": ["co2-WI", "gdp-WI"],
                  "Wyoming": ["co2-WY", "gdp-WY"],
                }
//list all state
var allgroups = [
                  "California",
                  "United States",
                  "Alabama",
                  "Alaska",
                  "Arizona",
                  "Arkansas",
                  "Colorado",
                  "Connecticut",
                  "Delaware",
                  "District of Columbia",
                  "Florida",
                  "Georgia",
                  "Hawaii",
                  "Idaho",
                  "Illinois",
                  "Indiana",
                  "Iowa",
                  "Kansas",
                  "Kentucky",
                  "Louisiana",
                  "Maine",
                  "Maryland",
                  "Massachusetts",
                  "Michigan",
                  "Minnesota",
                  "Mississippi",
                  "Missouri",
                  "Montana",
                  "Nebraska",
                  "Nevada",
                  "New Hampshire",
                  "New Jersey",
                  "New Mexico",
                  "New York",
                  "North Carolina",
                  "North Dakota",
                  "Ohio",
                  "Oklahoma",
                  "Oregon",
                  "Pennsylvania",
                  "Rhode Island",
                  "South Carolina",
                  "South Dakota",
                  "Tennessee",
                  "Texas",
                  "Utah",
                  "Vermont",
                  "Virginia",
                  "Washington",
                  "West Virginia",
                  "Wisconsin",
                  "Wyoming"
                ]


d3.csv("https://tabinda-s.github.io/climate4policy/data/ghg-gdp/ghg-gdp-data.csv", function(error, data) { 
  color.domain(d3.keys(data[0]).filter(function(key) { // Set the domain of the color ordinal scale to be all the csv headers except "date", matching a color to an issue
    return key !== "year"; 
  }));
 
  data.forEach(function(d) { // Make every date in the csv data a javascript date object format
   
    d.year = parseDate(d.year);
    
  });

  var categories = color.domain().map(function(name) { // Nest the data into an array of objects with new keys

    return {
      name: name, // "name": the csv headers except date
      value: data.map(function(d) { // "values": which has an array of the dates and ratings
        return {
          date: d.year, 
          rating: +(d[name]),
          };
      }),
      visible: (name === "co2-CA" || name ==="gdp-CA" ? true : false) // "visible": all false except for economy which is true.
    };
  });

categoryGroups = []

allgroups.forEach(function(groupval) {
  

  var key = groupval;
  var obj = {};
  obj[key] = [];
  categoryGroups.push(obj);  
   
  
});

//Group data by dual line group
Object.keys(categories).forEach(function(key) {
  Object.keys(categoryGroups).forEach(function(groupkey) {
    var groupVal = Object.keys(categoryGroups[groupkey])[0]
    if (groupVal===groups[categories[key].name]){
    
     categoryGroups[groupkey][groupVal].push(categories[key])
    }
   
  });
});

//create dictionary to feed to findMax function
categoriesStart = {}
categoriesStart["co2-CA"]=[]
categoriesStart["co2-CA"].push(categories[0])
categoriesStart["co2-CA"].push(categories[1])

maxY = findMaxY(categoriesStart); // Find max Y rating value categories data with "visible"; true

maxYRight = findMaxYRight(categoriesStart);
//console.log(categories)
xScale.domain(d3.extent(data, function(d) { return d.year; })); // extent = highest and lowest points, domain is data, range is bouding box

yScale.domain([0, maxY
  //d3.max(categories, function(c) { return d3.max(c.values, function(v) { return v.rating; }); })
]);
yScaleRight.domain([0, maxYRight
  //d3.max(categories, function(c) { return d3.max(c.values, function(v) { return v.rating; }); })
]);


// draw line graph
svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis);
  

svg.append("g")
    .attr("class", "y axis")
    .style("fill", "#e60000")
    .call(yAxis)
  .append("text")
    .attr("transform", "rotate(-90)")
    .attr("y", 6)
    .attr("x", -10)
    .attr("dy", "1em")
    .style("text-anchor", "end")
    .text("co2-CA")
    .attr("id", function(d) { 
     
       

      
      return "ylabel" // If array key "visible" = true then draw line, if not then don't 
    });
    


svg.append("g")       
      .attr("class", "y axis right")  
      .attr("transform", "translate(" + width + " ,0)") 
      .style("fill", "#4785b8")   
      .call(yAxisRight)    
      .append("text")
    .attr("transform", "rotate(-90)")
    .attr("y", -15)
    .attr("x", -10)
    .attr("dy", "1em")
    .style("text-anchor", "end")
    .text("gdp-CA")
    .attr("id", function(d) { 
     
       

      
      return "ylabelright" // If array key "visible" = true then draw line, if not then don't 
    });


var issue = svg.selectAll(".issue")
    .data(categoryGroups) // Select nested data and append to new svg group elements
  .enter().append("g")
    .attr("class", "issue");   

issue.append("path")
    .attr("class", "line")
    .style("pointer-events", "none") // Stop line interferring with cursor
    .attr("id", function(d) {
      //add id based from column header name
      var groupname =Object.keys(d)[0]
      var innerGroup = d[groupname][0].name
      
      return "line-" + innerGroup.replace(" ", "").replace("/", ""); // Give line id of line-(insert issue name, with any spaces replaced with no spaces)
    })
    .attr("d", function(d) { 
      var groupname =Object.keys(d)[0]
        var innerGroup = d[groupname][0]

      return innerGroup.visible ? line(innerGroup.value) : null; // If array key "visible" = true then draw line, if not then don't

    })
    .attr("clip-path", "url(#clip)")//use clip path to make irrelevant part invisible
    .style("stroke", function(d) { 

      var groupname =Object.keys(d)[0]
      var innerGroup = d[groupname][0]
      return d3.rgb("#e60000"); });

//Add second path for right y axis
issue.append("path")
  .attr("class", "line")
  .style("pointer-events", "none") // Stop line interferring with cursor
  .attr("id", function(d) {
    
    var groupname =Object.keys(d)[0]
    var innerGroup = d[groupname][1].name
    return "line-" + innerGroup.replace(" ", "").replace("/", ""); // Give line id of line-(insert issue name, with any spaces replaced with no spaces)
  })
  .attr("d", function(d) { 
    var groupname =Object.keys(d)[0]
      var innerGroup = d[groupname][1]
     
      
    return innerGroup.visible ? lineRight(innerGroup.value) : null; // If array key "visible" = true then draw line, if not then don't 
  })
  .attr("clip-path", "url(#clip)")//use clip path to make irrelevant part invisible
  .style("stroke", function(d) { 

    var goupname =Object.keys(d)[0]
    return d3.rgb("#4785b8") });


// draw legend
var legendSpace = 100 / categoryGroups.length; // 450/number of issues (ex. 40)    

var selector = d3.select("#dropdown")
    .append("select")
    .attr("id", "stateselector")
    .selectAll("option")
    .data(allgroups)
    .enter().append("option")
    .text(function(d) { return d; })
    .attr("value", function (d, i) {
      return d;
    });

d3.select("#stateselector")
  .on("change", function(d) {


    issue.selectAll("path.line")
        .transition()
        .attr("d", function(d){
          
          
          return null; // If d.visible is true then draw line for this d selection
        })


    index = this.value;
    var dataState
    categoryGroups.forEach(function(element){
      
        if (element[index]){
         
          dataState = element
        }
      })
      
      //var selected = categoryGroups[0]

      var innerGroup = dataState[index][0]
      var innerGroup2 =dataState[index][1]
     
      var innerGroupName = "#"+"line-" + innerGroup.name.replace(" ", "").replace("/", "");
      var innerGroupName2 = "#"+"line-" + innerGroup2.name.replace(" ", "").replace("/", "");
     
      //line1 = d3.select(innerGroupName)  
       
      innerGroup.visible = true; // If array key for this data selection is "visible" = true then make it false, if false then make it true
      innerGroup2.visible = true;

      maxY = findMaxY(dataState); // Find max Y rating value categories data with "visible"; true

      maxYRight = findMaxYRight(dataState);
      
      yScale.domain([0,maxY]); // Redefine yAxis domain based on highest y value of categories data with "visible"; true
      svg.select(".y.axis")
        .transition()
        .call(yAxis)
        .select('#ylabel')
        .text(innerGroup.name);

       // Redefine yAxis domain based on highest y value of categories data with "visible"; true
      yScaleRight.domain([0,maxYRight]);
      svg.selectAll(".y.axis.right")
        .transition()
        .call(yAxisRight)  
        .select('#ylabelright')
        .text(innerGroup2.name);

        issue.select(innerGroupName)
        .transition()
        .attr("d", function(d){
          var groupname =Object.keys(d)[0]
          var innerGroup = d[groupname][0]
          
          return innerGroup.visible ? line(innerGroup.value) : null; // If d.visible is true then draw line for this d selection
        })

      issue.select(innerGroupName2)
        .transition()
        .attr("d", function(d){
          var groupname =Object.keys(d)[0]
          var innerGroup = d[groupname][1]
          
          return innerGroup.visible ? lineRight(innerGroup.value) : null; // If d.visible is true then draw line for this d selection
        })
  })
}); // End Data callback function


  function findMaxY(data){  // Define function "findMaxY"
     
      var groupname =Object.keys(data)[0]
      var innerGroup = data[groupname][0]
      
      
        return d3.max(innerGroup.value, function(value) { // Return max rating value
          return value.rating; })
       
  }

  function findMaxYRight(data){  // Define function "findMaxY"
    
      var groupname =Object.keys(data)[0]
      var innerGroup = data[groupname][1]
      
      
        return d3.max(innerGroup.value, function(value) { // Return max rating value
          return value.rating; })    
  }
