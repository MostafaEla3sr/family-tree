import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphview/GraphView.dart';

import '../../data/cubit/family_tree_cubit.dart';
import '../../data/models/family_member_model.dart';

class FamilyTreeScreen extends StatefulWidget {
  @override
  _FamilyTreeScreenState createState() => _FamilyTreeScreenState();
}

class _FamilyTreeScreenState extends State<FamilyTreeScreen> {
  final Graph graph = Graph()..isTree = true;

  final BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration()
    ..siblingSeparation = (100)
    ..levelSeparation = (150)
    ..subtreeSeparation = (150)
    ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;

  final TransformationController _transformationController =
      TransformationController();
  @override
  void initState() {
    super.initState();
    // Fetch the root member when the view is initialized
    context.read<FamilyTreeCubit>().fetchRootMember();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerRootNode();
    });
  }

  void _centerRootNode() {
    Size size = MediaQuery.of(context).size;
    _transformationController.value = Matrix4.identity()
      ..translate(size.width / 2 - 50,
          size.height / 4 - 50); // Adjust the values to fit your graph
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Family Tree'),
      ),
      body: BlocBuilder<FamilyTreeCubit, List<FamilyMember>>(
        builder: (context, familyMembers) {
          if (familyMembers.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            ); // Show a loading indicator
          } else {
            _buildGraph(familyMembers); // Build the graph with family members

            // Ensure the graph has nodes before rendering
            if (graph.nodes.isEmpty) {
              return Center(
                child: Text("No family members found."),
              );
            }

            return Container(
              height: MediaQuery.of(context).size.height *
                  0.7, // Adjust height as needed
              child: GraphView(
                graph: graph,
                algorithm: BuchheimWalkerAlgorithm(
                  builder,
                  TreeEdgeRenderer(builder),
                ),
                builder: (Node node) {
                  if (node.key != null && node.key!.value is FamilyMember) {
                    var familyMember = node.key!.value as FamilyMember;
                    return _buildNodeWidget(familyMember);
                  }
                  return Container(); // Return an empty container if the node is invalid
                },
              ),
            );
          }
        },
      ),
    );
  }

  // Build the graph from the family members list
  void _buildGraph(List<FamilyMember> familyMembers) {
    graph.nodes.clear();
    graph.edges.clear();

    Map<int, Node> nodeMap = {}; // To avoid duplicate nodes

    for (var member in familyMembers) {
      var parentNode = nodeMap.putIfAbsent(member.id, () => Node.Id(member));

      if (member.children != null && member.children.isNotEmpty) {
        for (var child in member.children) {
          var childNode = nodeMap.putIfAbsent(child.id, () => Node.Id(child));
          graph.addEdge(
              parentNode, childNode); // Add an edge between parent and child
        }
      }
    }
  }

  // Build the widget for each node (family member)
  Widget _buildNodeWidget(FamilyMember member) {
    return GestureDetector(
      onTap: () {
        if (member.children == null || member.children.isEmpty) {
          // Fetch children if not already loaded
          context.read<FamilyTreeCubit>().fetchChildren(member.id);
        }
      },
      child: Container(
        width: 60, // Increased width for better visibility
        height: 60, // Increased height for better visibility
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blueAccent),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content
          children: [
            Text(
              member.fullName ?? 'Unknown',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center, // Center the text
            ),
            // Uncomment to show icon for expandable members
            /* if (member.sonsCount != null && member.sonsCount > 0)
              Icon(Icons.add, size: 16),*/
          ],
        ),
      ),
    );
  }
}
