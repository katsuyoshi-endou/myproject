var SkillCheckSteps = {

  draw: function(scs_skills, buyer_shikaku_2, buyer_shikaku_1) {
    var skills = this.prepareScsSkills(scs_skills);
    var dataset = {
      kyu2Nintei: ("認定済" === buyer_shikaku_2),
      kyu1Nintei: ("認定済" === buyer_shikaku_1),
      kyu2: this.makeKyu2List(skills),
      kyu1: this.makeKyu1List(skills)
    };
    this.drawWireframe();
    this.drawSkills(dataset);
  },

  prepareScsSkills: function(scs_skills) {
    var list = scs_skills.filter(function(d){
      if (d.buyer_kenshu_kamoku_cd === '22901') {
        // [除外] 基幹職向けバイヤー２級認定集中セミナー
        return false;
      }
      return !!d.buyer_kenshu_jukojokyo.match(/^(受講済|講師|集中セミナー受講済)$/);
    });
    list.sort(function(a,b){
      if (a.buyer_kenshu_shuryobi < b.buyer_kenshu_shuryobi) return -1;
      if (a.buyer_kenshu_shuryobi > b.buyer_kenshu_shuryobi) return  1;
      return 0;
    });
    return list;
  },

  makeKyu2List: function(scs_skills) {
    var kyu2_max_sentaku_cnt = 2;
    var result = scs_skills.filter(function(d){
      return !!~d.buyer_kenshu_kamoku_gr.indexOf('２級');
    }).map(function(d){
      var hissu = !!~d.buyer_kenshu_hissu_kbn.indexOf('必須');
      return {
        type: hissu ? 'h' : 's',
        label: d.buyer_kenshu_ryakusho
      };
    }).filter(function(d){
      if (d.type === 'h') { return true; }
      if (d.type === 's' && kyu2_max_sentaku_cnt > 0) {
        kyu2_max_sentaku_cnt--;
        return true;
      }
      return false;
    });
    return result;
  },

  makeKyu1List: function(scs_skills) {
    var kyu1_max_sentaku_cnt = 1;
    var result = scs_skills.filter(function(d){
      return !!~d.buyer_kenshu_kamoku_gr.indexOf('１級');
    }).map(function(d){
      var hissu = !!~d.buyer_kenshu_hissu_kbn.indexOf('必須');
      return {
        type: hissu ? 'h' : 's',
        label: d.buyer_kenshu_ryakusho
      };
    }).filter(function(d){
      if (d.type === 'h') { return true; }
      if (d.type === 's' && kyu1_max_sentaku_cnt > 0) {
        kyu1_max_sentaku_cnt--;
        return true;
      }
      return false;
    });
    return result;
  },

  drawWireframe: function() {
    var dataset = this.getWireDataset();
    var svg = d3.select("#SkillCheckSteps").append("svg")
        .attr({
          width: 800,
          height: 400,
        })
    ;
    svg.append('g')
      .classed('buyer2box', true)
      .append('rect')
      .attr('x', 10+55*9)
      .attr('y', 350 - (7*25))
      .attr('width',55*4)
      .attr('height', 25*8)
      .attr('fill', '#fff')
      .attr('stroke', '#aaa')
      .attr('stroke-width', 1)
    ;
    svg.append('g')
      .classed('buyer1box', true)
      .append('rect')
      .attr('x', 10+55*13)
      .attr('y', 350 - (10*25))
      .attr('width',55)
      .attr('height', 25*11)
      .attr('fill', '#fff')
      .attr('stroke', '#aaa')
      .attr('stroke-width', 1)
    ;
    svg.selectAll('g.box').data(dataset).enter()
      .append('g')
      .classed('box', true)
      .attr('ph', function(d){return d.ph;})
      .attr('st', function(d){return d.st;})
      .append('rect')
      .attr('x', function(d){return 10+(d.ph * 55);})
      .attr('y', function(d){return 375 - (d.st*25);})
      .attr('width',function(d){return 55;})
      .attr('height', function(d){return 25;})
      .attr('fill', function(d){return '#fff';})
      .attr('stroke', function(d){return '#aaa';})
      .attr('stroke-width', function(d){return 1;})
    ;
    svg.selectAll('rect.box')
      .classed('bbb', true)
    ;
  },

  getWireDataset: function() {
    return [
      { 'ph': 1, 'st': 1 },

      { 'ph': 2, 'st': 1 },
      { 'ph': 2, 'st': 2 },

      { 'ph': 3, 'st': 1 },
      { 'ph': 3, 'st': 2 },
      { 'ph': 3, 'st': 3 },

      { 'ph': 4, 'st': 1 },
      { 'ph': 4, 'st': 2 },
      { 'ph': 4, 'st': 3 },
      { 'ph': 4, 'st': 4 },

      { 'ph': 5, 'st': 1 },
      { 'ph': 5, 'st': 2 },
      { 'ph': 5, 'st': 3 },
      { 'ph': 5, 'st': 4 },
      { 'ph': 5, 'st': 5 },

      { 'ph': 6, 'st': 1 },
      { 'ph': 6, 'st': 2 },
      { 'ph': 6, 'st': 3 },
      { 'ph': 6, 'st': 4 },
      { 'ph': 6, 'st': 5 },
      { 'ph': 6, 'st': 6 },

      { 'ph': 7, 'st': 1 },
      { 'ph': 7, 'st': 2 },
      { 'ph': 7, 'st': 3 },
      { 'ph': 7, 'st': 4 },
      { 'ph': 7, 'st': 5 },
      { 'ph': 7, 'st': 6 },
      { 'ph': 7, 'st': 7 },

      { 'ph': 8, 'st': 1 },
      { 'ph': 8, 'st': 2 },
      { 'ph': 8, 'st': 3 },
      { 'ph': 8, 'st': 4 },
      { 'ph': 8, 'st': 5 },
      { 'ph': 8, 'st': 6 },
      { 'ph': 8, 'st': 7 },
      { 'ph': 8, 'st': 8 },

      { 'ph': 10, 'st': 9 },

      { 'ph': 11, 'st': 9 },
      { 'ph': 11, 'st': 10 },

      { 'ph': 12, 'st': 9 },
      { 'ph': 12, 'st': 10 },
      { 'ph': 12, 'st': 11 },
    ];
  },

  drawSkills: function(skills) {
    var all = {
      kyu2phases: [
        skills.kyu2.slice(0,1),
        skills.kyu2.slice(0,2),
        skills.kyu2.slice(0,3),
        skills.kyu2.slice(0,4),
        skills.kyu2.slice(0,5),
        skills.kyu2.slice(0,6),
        skills.kyu2.slice(0,7),
        skills.kyu2.slice(0,8)
      ],
      kyu1phases: [
        skills.kyu1.slice(0,1),
        skills.kyu1.slice(0,2),
        skills.kyu1.slice(0,3)
      ]
    };
    var crrPhase = this.detectCrrPhase(skills);

    var svg = d3.select("#SkillCheckSteps svg");

    var imgSize = 60;
    svg.append('g').append('image')
      .attr('x', function(d){ return 10+(crrPhase * 55)+27 - (imgSize/2); })
      .attr('y', function(d){
        var z = 0;
        if (crrPhase >= 9) {
          z = crrPhase === 13 ? 50 : 25;
        }
        return 350-(crrPhase * 25)+10+z - (imgSize/2+15);
      })
      .attr('width', function(d){ return imgSize + 'px'})
      .attr('height', function(d){ return imgSize + 'px'})
      .attr('xlink:href', '../view/talent/profile/addons/pict.png')
    ;

    //svg.append('text')
    //  .attr('x', 50)
    //  .attr('y', 50)
    //  .text('Current Phase: '+crrPhase)
    //;

    all.kyu2phases.forEach(function(arr,i){
      var ph = i + 1;
      svg.selectAll('g.box text').data(arr).enter()
        .append('text')
        .attr('x', function(d){return 10+(ph * 55)+27;})
        .attr('y', function(d,i){return 350 - (i*25) + 16;})
        .attr('text-anchor', "middle")
        .style('font-family', 'Meiryo, sans-serif')
        .style('font-size', '11px')
        .text(function(d){ return ph <= crrPhase ? d.label : ''; })
      ;
      // Box Coloring - Buyer2
      svg.selectAll('g.box[ph="'+ph+'"] rect').data(arr)
        .attr('fill', function(d){
          var color = '#fff';
          if (ph <= crrPhase) {
            color = d.type === 'h' ? '#99FF99' : '#CCFFCC';
          }
          return color;
        })
      ;
    });
    all.kyu1phases.forEach(function(arr,i){
      var ph = 9 + i + 1;
      svg.selectAll('g.box text').data(arr).enter()
        .append('text')
        .attr('x', function(d){return 10+(ph * 55)+27;})
        .attr('y', function(d,i){return 350 - (i+8)*25 + 16;})
        .attr('text-anchor', "middle")
        .style('font-family', 'Meiryo, sans-serif')
        .style('font-size', '11px')
        .text(function(d){ return arr.length > i ? d.label : ''; })
      ;
      // Box Coloring - Buyer1
      svg.selectAll('g.box[ph="'+ph+'"] rect').data(arr)
        .attr('fill', function(d){
          var color = '#fff';
          if (arr.length > i) {
            color = d.type === 'h' ? '#66ccff' : '#DCE6F1';
          }
          return color;
        })
      ;
    });
    svg.select('.buyer2box').append('text')
      .attr('x', 10+55*8 + 165)
      .attr('y', 350 - (3*25))
      .attr('font-size', '11px')
      .attr('text-anchor', 'middle')
      .attr('writing-mode', 'tb')
      .attr('glyph-orientation-vertical', 'auto')
      .style('font-family', 'Meiryo, sans-serif')
      .style('font-weight', 'bold')
      .attr('fill', function(){ return skills.kyu2Nintei ? '#fff' : '#bbb'; })
      .text('バイヤー２級　認定')
    ;
    svg.select('.buyer2box rect')
      .attr('fill', function(){ return skills.kyu2Nintei ? '#00B050' : '#fff'; })
    ;
    svg.select('.buyer1box').append('text')
      .attr('x', 10+55*10 + 193)
      .attr('y', 350 - (4*25))
      .attr('font-size', '11px')
      .attr('text-anchor', 'middle')
      .attr('writing-mode', 'tb')
      .attr('glyph-orientation-vertical', 'auto')
      .style('font-family', 'Meiryo, sans-serif')
      .style('font-weight', 'bold')
      .attr('fill', function(){ return skills.kyu1Nintei ? '#fff' : '#bbb'; })
      .text('バイヤー１級　認定')
    ;
    svg.select('.buyer1box rect')
      .attr('fill', function(){ return skills.kyu1Nintei ? '#0070C0' : '#fff'; })
    ;
  },

  detectCrrPhase: function(skills) {
    var ph = 0;

    if (skills.kyu1Nintei) {
      return 13;
    }

    var k2 = skills.kyu2.filter(function(d){
      return !!d;
    });
    var k1 = skills.kyu1.filter(function(d){
      return !!d;
    });

    if (k2 && k2.length > 0) {
      ph = k2.length;

      if (skills.kyu2Nintei && k1 && k1.length >= 0) {
        ph = 9 + k1.length;
      }
    }
    // console.log(k1, k2, ph);
    return ph;
  }

}
