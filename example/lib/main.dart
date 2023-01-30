// Copyright (c) 2023- All flutter_graph_view authors. All rights reserved.
//
// This source code is licensed under Apache 2.0 License.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_graph_view/flutter_graph_view.dart';

void main() {
  var vertexes = <Map>{};
  var r = Random();
  for (var i = 0; i < 200; i++) {
    vertexes.add(
      {
        'id': 'node$i',
        'tag': 'tag${r.nextInt(9)}',
        'tags': [
          'tag${r.nextInt(4)}',
          if (r.nextBool()) 'tag${r.nextInt(4)}',
          if (r.nextBool()) 'tag${r.nextInt(8)}'
        ],
      },
    );
  }
  var edges = <Map>{};

  for (var i = 0; i < 200; i++) {
    edges.add({
      'srcId': 'node${i % 4}',
      'dstId': 'node$i',
      'edgeName': 'edge${r.nextInt(3)}',
      'ranking': r.nextInt(DateTime.now().millisecond),
    });
  }

  for (var i = 0; i < 20; i++) {
    edges.add({
      'srcId': 'node${r.nextInt(vertexes.length)}',
      'dstId': 'node${r.nextInt(vertexes.length)}',
      'edgeName': 'edge${r.nextInt(3)}',
      'ranking': r.nextInt(DateTime.now().millisecond),
    });
  }

  var data = {
    'vertexes': vertexes,
    'edges': edges,
  };

  runApp(MaterialApp(
    home: Scaffold(
      body: FlutterGraphWidget(
        data: data,
        algorithm: ForceDirected(),
        convertor: MapConvertor(),
        options: Options()
          ..graphStyle = (GraphStyle()
            // tagColor is prior to tagColorByIndex. use vertex.tags to get color
            ..tagColor = {'tag3': Colors.purple}
            ..tagColorByIndex = [
              Colors.blue,
              Colors.red,
              Colors.green,
              Colors.yellow,
            ])
          ..edgePanelBuilder = edgePanelBuilder
          ..vertexPanelBuilder = vertexPanelBuilder
          ..edgeShape = EdgeLineShape() // default is EdgeLineShape.
          ..vertexShape = VertexCircleShape(), // default is VertexCircleShape.
      ),
    ),
  ));
}

Widget edgePanelBuilder(Edge edge) {
  var c = (edge.start.cpn!.position + edge.end!.cpn!.position) / 2;
  return Stack(
    children: [
      Positioned(
        left: c.x + 5,
        top: c.y,
        child: SizedBox(
          width: 150,
          child: ColoredBox(
            color: Colors.white,
            child: ListTile(
              title: Text('${edge.edgeName} @${edge.ranking}'),
            ),
          ),
        ),
      )
    ],
  );
}

Widget vertexPanelBuilder(hoverVertex) {
  return Stack(
    children: [
      Positioned(
        left: hoverVertex.cpn!.position.x + hoverVertex.radius + 5,
        top: hoverVertex.cpn!.position.y - 20,
        child: SizedBox(
          width: 120,
          child: ColoredBox(
            color: Colors.white,
            child: ListTile(
              title: Text(
                'Id: ${hoverVertex.id}',
              ),
              subtitle: Text(
                  'Tag: ${hoverVertex.data['tag']}\nDegree: ${hoverVertex.degree}'),
            ),
          ),
        ),
      )
    ],
  );
}
