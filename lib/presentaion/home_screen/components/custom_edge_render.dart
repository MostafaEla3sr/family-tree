import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

class CustomEdgeRenderer extends EdgeRenderer {
  CustomEdgeRenderer(this.configuration);

  final BuchheimWalkerConfiguration configuration;
  var linePath = Path();

  @override
  void render(Canvas canvas, Graph graph, Paint paint) {
    var levelSeparationHalf = configuration.levelSeparation / 2;

    for (var node in graph.nodes) {
      var children = graph.successorsOf(node);

      for (var child in children) {
        var edge = graph.getEdgeBetween(node, child);
        var edgePaint = (edge?.paint ?? paint)..style = PaintingStyle.stroke;
        linePath.reset();
        switch (configuration.orientation) {
          case BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM:
            linePath.moveTo((child.x + child.width / 2), child.y);
            linePath.lineTo(
                child.x + child.width / 2, child.y - levelSeparationHalf);
            linePath.lineTo(
                node.x + node.width / 2, child.y - levelSeparationHalf);
            linePath.moveTo(
                node.x + node.width / 2, child.y - levelSeparationHalf);
            linePath.lineTo(node.x + node.width / 2, node.y + node.height);
            break;
          case BuchheimWalkerConfiguration.ORIENTATION_BOTTOM_TOP:
            linePath.moveTo(child.x + child.width / 2, child.y + child.height);
            linePath.lineTo(child.x + child.width / 2,
                child.y + child.height + levelSeparationHalf);
            linePath.lineTo(node.x + node.width / 2,
                child.y + child.height + levelSeparationHalf);
            linePath.moveTo(node.x + node.width / 2,
                child.y + child.height + levelSeparationHalf);
            linePath.lineTo(node.x + node.width / 2, node.y + node.height);
            break;
          case BuchheimWalkerConfiguration.ORIENTATION_LEFT_RIGHT:
            linePath.moveTo(child.x, child.y + child.height / 2);
            linePath.lineTo(
                child.x - levelSeparationHalf, child.y + child.height / 2);
            linePath.lineTo(
                child.x - levelSeparationHalf, node.y + node.height / 2);
            linePath.moveTo(
                child.x - levelSeparationHalf, node.y + node.height / 2);
            linePath.lineTo(node.x + node.width, node.y + node.height / 2);
            break;
          case BuchheimWalkerConfiguration.ORIENTATION_RIGHT_LEFT:
            linePath.moveTo(child.x + child.width, child.y + child.height / 2);
            linePath.lineTo(child.x + child.width + levelSeparationHalf,
                child.y + child.height / 2);
            linePath.lineTo(child.x + child.width + levelSeparationHalf,
                node.y + node.height / 2);
            linePath.moveTo(child.x + child.width + levelSeparationHalf,
                node.y + node.height / 2);
            linePath.lineTo(node.x + node.width, node.y + node.height / 2);
        }

        canvas.drawPath(linePath, edgePaint);

        // Draw circle at the end of the path (to node)
        var radius = 5.0;
        var circlePaint = Paint()
          ..color = Colors.green
          ..style = PaintingStyle.fill;

        canvas.drawCircle(
            Offset(child.x + child.width / 2, child.y), radius, circlePaint);
        canvas.drawCircle(Offset(node.x + node.width / 2, node.y + node.height),
            radius, circlePaint);
      }
    }
  }
}
