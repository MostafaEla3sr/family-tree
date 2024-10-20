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
      body: Stack(
        children: [
          Image.asset(
            'assets/images/background.png',
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            fit: BoxFit.cover,
          ),
          BlocBuilder<FamilyTreeCubit, List<FamilyMember>>(
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
                  boundaryMargin: const EdgeInsets.all(double.infinity),
                  minScale: 0.01,
                  maxScale: 5.6,
                  transformationController: _transformationController,
                  child: GraphView(
                    graph: graph,
                    algorithm: BuchheimWalkerAlgorithm(
                        builder, TreeEdgeRenderer(builder)),
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
        ],
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
    return Column(
      children: [
        InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  child: Text(member.firstName,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
                Container(
                  width: 50,
                  margin: const EdgeInsets.symmetric(
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(25),
                    ),
                    color: nodeColor(
                      gender: member.gender,
                      isAlive: member.isAlive,
                    ),
                  ),
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        member.sequenceNumber.toString(),
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (member.gender == "Male" && member.sonsCount! > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Visibility(
              visible: member.children.isNotEmpty,
              replacement: InkWell(
                onTap: () async {},
                child: const Icon(
                  Icons.add,
                  size: 18,
                ),
              ),
              child: InkWell(
                onTap: () async {},
                child: const Icon(
                  Icons.minimize,
                  size: 18,
                ),
              ),
            ),
          ),
      ],
    );
    return GestureDetector(
      onTap: () {
        print("object");
        context.read<FamilyTreeCubit>().fetchChildren(member.id);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: Color(0xFFCE9D4D),
          borderRadius: BorderRadius.circular(100),
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
              const Positioned(
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

Color nodeColor({
  required String gender,
  String? isAlive,
}) {
  Color edgeColor;
  if (gender == "Male") {
    if (isAlive == "N") {
      edgeColor = const Color(0xff90E3FF);
    } else {
      edgeColor = const Color(0xff00BFFF);
    }
  } else if (gender == "Female") {
    if (isAlive == "N") {
      edgeColor = const Color(0xffFFB6EF);
    } else {
      edgeColor = const Color(0xffF20ECD);
    }
  } else {
    edgeColor = Colors.pink;
  }

  return edgeColor;
}
