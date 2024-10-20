import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphview/GraphView.dart';

import '../../data/cubit/family_tree_cubit.dart';
import '../../data/models/family_member_model.dart';

class FamilyTreeScreen extends StatefulWidget {
  const FamilyTreeScreen({super.key});

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
        title: const Text('Family Tree'),
      ),
      body: BlocBuilder<FamilyTreeCubit, List<FamilyMember>>(
        builder: (context, familyMembers) {
          if (familyMembers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            _buildGraph(familyMembers);

            if (graph.nodes.isEmpty) {
              return const Center(child: Text("No family members found."));
            }

            return InteractiveViewer(
              constrained: false,
              boundaryMargin: const EdgeInsets.all(1000),
              minScale: 0.01,
              maxScale: 5.6,
              transformationController: _transformationController,
              child: GraphView(
                graph: graph,
                algorithm:
                    BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
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

  // Updated widget to show '+' icon if the member has children
  Widget _buildNodeWidget(FamilyMember member) {
    return GestureDetector(
      onTap: () {
        if (member.children == null || member.children.isEmpty) {
          context
              .read<FamilyTreeCubit>()
              .fetchChildren(member.id); // Fetch children if not loaded
        }
      },
      child: Container(
        width: 120,
        height: 60,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blueAccent),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                member.fullName ?? 'Unknown',
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            if (member.children == null || member.children.isEmpty)
              Positioned(
                top: 0,
                right: 0,
                child: Icon(
                  Icons.add_circle, // Plus icon
                  color: Colors.green,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
