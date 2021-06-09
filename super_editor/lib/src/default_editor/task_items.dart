import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_editor/src/infrastructure/_logging.dart';
import 'package:super_editor/super_editor.dart';

final _log = Logger(scope: 'super_note_editor.dart');

Widget? doneTaskComponentBuilder(ComponentContext componentContext) {
  final taskItemNode = componentContext.documentNode;
  if (taskItemNode is! TaskItemNode) {
    return null;
  }

  if (taskItemNode.taskType != TaskItemType.done) {
    return null;
  }

  final textSelection =
      componentContext.nodeSelection?.nodeSelection as TextSelection?;
  final showCaret = componentContext.showCaret &&
      (componentContext.nodeSelection?.isExtent ?? false);

  return DoneTaskItemComponent(
    textKey: componentContext.componentKey,
    text: taskItemNode.text,
    styleBuilder: componentContext.extensions[textStylesExtensionKey],
    textSelection: textSelection,
    selectionColor: (componentContext.extensions[selectionStylesExtensionKey]
            as SelectionStyle)
        .selectionColor,
    showCaret: showCaret,
    caretColor: (componentContext.extensions[selectionStylesExtensionKey]
            as SelectionStyle)
        .textCaretColor,
  );
}

Widget? openTaskComponentBuilder(ComponentContext componentContext) {
  final taskItemNode = componentContext.documentNode;
  if (taskItemNode is! TaskItemNode) {
    return null;
  }

  if (taskItemNode.taskType != TaskItemType.open) {
    return null;
  }

  final textSelection =
      componentContext.nodeSelection?.nodeSelection as TextSelection?;
  final showCaret = componentContext.showCaret &&
      (componentContext.nodeSelection?.isExtent ?? false);

  return OpenTaskItemComponent(
    textKey: componentContext.componentKey,
    text: taskItemNode.text,
    styleBuilder: componentContext.extensions[textStylesExtensionKey],
    textSelection: textSelection,
    selectionColor: (componentContext.extensions[selectionStylesExtensionKey]
            as SelectionStyle)
        .selectionColor,
    showCaret: showCaret,
    caretColor: (componentContext.extensions[selectionStylesExtensionKey]
            as SelectionStyle)
        .textCaretColor,
  );
}

class TaskItemNode extends TextNode {
  TaskItemNode.open({
    required String id,
    required AttributedText text,
    Map<String, dynamic>? metadata,
  })  : taskType = TaskItemType.open,
        super(
          id: id,
          text: text,
          metadata: metadata,
        );

  TaskItemNode.done({
    required String id,
    required AttributedText text,
    Map<String, dynamic>? metadata,
  })  : taskType = TaskItemType.done,
        super(
          id: id,
          text: text,
          metadata: metadata,
        );

  TaskItemNode({
    required String id,
    required TaskItemType itemType,
    required AttributedText text,
    Map<String, dynamic>? metadata,
  })  : taskType = itemType,
        super(
          id: id,
          text: text,
          metadata: metadata,
        );

  final TaskItemType taskType;

  @override
  bool hasEquivalentContent(DocumentNode other) {
    return other is TaskItemNode &&
        taskType == other.taskType &&
        text == other.text;
  }
}

enum TaskItemType { open, done }

class DoneTaskItemComponent extends StatelessWidget {
  const DoneTaskItemComponent({
    Key? key,
    required this.textKey,
    required this.text,
    required this.styleBuilder,
    this.dotBuilder = _defaultDoneTaskItemDotBuilder,
    this.textSelection,
    this.selectionColor = Colors.lightBlueAccent,
    this.showCaret = false,
    this.caretColor = Colors.black,
    this.showDebugPaint = false,
  }) : super(key: key);

  final GlobalKey textKey;
  final AttributedText text;
  final AttributionStyleBuilder styleBuilder;
  final DoneTaskItemDotBuilder dotBuilder;

  final TextSelection? textSelection;
  final Color selectionColor;
  final bool showCaret;
  final Color caretColor;
  final bool showDebugPaint;

  @override
  Widget build(BuildContext context) {
    final firstLineHeight = styleBuilder({}).fontSize;
    final manualVerticalAdjustment = 2.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: manualVerticalAdjustment),
          decoration: BoxDecoration(
            border: Border.all(
                width: 1,
                color: showDebugPaint ? Colors.grey : Colors.transparent),
          ),
          child: SizedBox(
            height: firstLineHeight,
            child: dotBuilder(context, this),
          ),
        ),
        Expanded(
          child: TextComponent(
            key: textKey,
            text: text,
            textStyleBuilder: styleBuilder,
            textSelection: textSelection,
            selectionColor: selectionColor,
            showCaret: showCaret,
            caretColor: caretColor,
            showDebugPaint: showDebugPaint,
          ),
        ),
      ],
    );
  }
}

typedef DoneTaskItemDotBuilder = Widget Function(
    BuildContext, DoneTaskItemComponent);

Widget _defaultDoneTaskItemDotBuilder(
    BuildContext context, DoneTaskItemComponent component) {
  return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () => print("uncheck"),
        child: const Icon(Icons.check_box_outlined),
      ));
}

class OpenTaskItemComponent extends StatelessWidget {
  const OpenTaskItemComponent({
    Key? key,
    required this.textKey,
    required this.text,
    required this.styleBuilder,
    this.dotBuilder = _defaultOpenTaskItemDotBuilder,
    this.textSelection,
    this.selectionColor = Colors.lightBlueAccent,
    this.showCaret = false,
    this.caretColor = Colors.black,
    this.showDebugPaint = false,
  }) : super(key: key);

  final GlobalKey textKey;
  final AttributedText text;
  final AttributionStyleBuilder styleBuilder;
  final OpenTaskItemDotBuilder dotBuilder;

  final TextSelection? textSelection;
  final Color selectionColor;
  final bool showCaret;
  final Color caretColor;
  final bool showDebugPaint;

  @override
  Widget build(BuildContext context) {
    final firstLineHeight = styleBuilder({}).fontSize;
    final manualVerticalAdjustment = 2.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: manualVerticalAdjustment),
          decoration: BoxDecoration(
            border: Border.all(
                width: 1,
                color: showDebugPaint ? Colors.grey : Colors.transparent),
          ),
          child: SizedBox(
            height: firstLineHeight,
            child: dotBuilder(context, this),
          ),
        ),
        Expanded(
          child: TextComponent(
            key: textKey,
            text: text,
            textStyleBuilder: styleBuilder,
            textSelection: textSelection,
            selectionColor: selectionColor,
            showCaret: showCaret,
            caretColor: caretColor,
            showDebugPaint: showDebugPaint,
          ),
        ),
      ],
    );
  }
}

typedef OpenTaskItemDotBuilder = Widget Function(
    BuildContext, OpenTaskItemComponent);

Widget _defaultOpenTaskItemDotBuilder(
    BuildContext context, OpenTaskItemComponent component) {
  return Align(
    alignment: Alignment.centerRight,
    child: GestureDetector(
        onTap: () => print("tap"),
        child: const Icon(Icons.check_box_outline_blank)),
  );
}

class CheckTaskItemCommand implements EditorCommand {
  CheckTaskItemCommand({
    required this.nodeId,
  });

  final String nodeId;

  @override
  void execute(Document document, DocumentEditorTransaction transaction) {
    // TODO: figure out how node changes should work in terms of
    //       a DocumentEditorTransaction (#67)
    final node = document.getNodeById(nodeId);
    final taskItem = node as TaskItemNode;
  }
}

class UnCheckTaskItemCommand implements EditorCommand {
  UnCheckTaskItemCommand({
    required this.nodeId,
  });

  final String nodeId;

  @override
  void execute(Document document, DocumentEditorTransaction transaction) {
    final node = document.getNodeById(nodeId);
    final taskItem = node as TaskItemNode;
  }
}

class ConvertTaskItemToParagraphCommand implements EditorCommand {
  ConvertTaskItemToParagraphCommand({
    required this.nodeId,
    this.paragraphMetadata,
  });

  final String nodeId;
  final Map<String, dynamic>? paragraphMetadata;

  @override
  void execute(Document document, DocumentEditorTransaction transaction) {
    final node = document.getNodeById(nodeId);
    final taskItem = node as TaskItemNode;

    final newParagraphNode = ParagraphNode(
      id: taskItem.id,
      text: taskItem.text,
      metadata: paragraphMetadata ?? {},
    );
    final taskItemIndex = document.getNodeIndex(taskItem);
    transaction
      ..deleteNodeAt(taskItemIndex)
      ..insertNodeAt(taskItemIndex, newParagraphNode);
  }
}

class ConvertParagraphToTaskItemCommand implements EditorCommand {
  ConvertParagraphToTaskItemCommand({
    required this.nodeId,
    required this.taskType,
  });

  final String nodeId;
  final TaskItemType taskType;

  @override
  void execute(Document document, DocumentEditorTransaction transaction) {
    final node = document.getNodeById(nodeId);
    final paragraphNode = node as ParagraphNode;

    final newTaskItemNode = TaskItemNode(
      id: paragraphNode.id,
      itemType: taskType,
      text: paragraphNode.text,
    );
    final paragraphIndex = document.getNodeIndex(paragraphNode);
    transaction
      ..deleteNodeAt(paragraphIndex)
      ..insertNodeAt(paragraphIndex, newTaskItemNode);
  }
}

class ChangeTaskItemTypeCommand implements EditorCommand {
  ChangeTaskItemTypeCommand({
    required this.nodeId,
    required this.newType,
  });

  final String nodeId;
  final TaskItemType newType;

  @override
  void execute(Document document, DocumentEditorTransaction transaction) {
    final existingTaskItem = document.getNodeById(nodeId) as TaskItemNode;

    final newTaskItemNode = TaskItemNode(
      id: existingTaskItem.id,
      itemType: newType,
      text: existingTaskItem.text,
    );
    final nodeIndex = document.getNodeIndex(existingTaskItem);
    transaction
      ..deleteNodeAt(nodeIndex)
      ..insertNodeAt(nodeIndex, newTaskItemNode);
  }
}

class SplitTaskItemCommand implements EditorCommand {
  SplitTaskItemCommand({
    required this.nodeId,
    required this.splitPosition,
    required this.newNodeId,
  });

  final String nodeId;
  final TextPosition splitPosition;
  final String newNodeId;

  @override
  void execute(Document document, DocumentEditorTransaction transaction) {
    final node = document.getNodeById(nodeId);
    final taskItemNode = node as TaskItemNode;
    final text = taskItemNode.text;
    final startText = text.copyText(0, splitPosition.offset);
    final endText = splitPosition.offset < text.text.length
        ? text.copyText(splitPosition.offset)
        : AttributedText();
    _log.log('SplitTaskItemCommand', 'Splitting task item:');
    _log.log('SplitTaskItemCommand', ' - start text: "$startText"');
    _log.log('SplitTaskItemCommand', ' - end text: "$endText"');

    // Change the current node's content to just the text before the caret.
    _log.log('SplitTaskItemCommand',
        ' - changing the original task item text due to split');
    // TODO: figure out how node changes should work in terms of
    //       a DocumentEditorTransaction (#67)
    taskItemNode.text = startText;

    // Create a new node that will follow the current node. Set its text
    // to the text that was removed from the current node.
    final newNode = taskItemNode.taskType == TaskItemType.open
        ? TaskItemNode.open(
            id: newNodeId,
            text: endText,
          )
        : TaskItemNode.done(
            id: newNodeId,
            text: endText,
          );

    // Insert the new node after the current node.
    _log.log('SplitTaskItemCommand', ' - inserting new node in document');
    transaction.insertNodeAfter(
      previousNode: node,
      newNode: newNode,
    );

    _log.log('SplitTaskItemCommand',
        ' - inserted new node: ${newNode.id} after old one: ${node.id}');
  }
}

ExecutionInstruction splitTaskItemWhenEnterPressed({
  required EditContext editContext,
  required RawKeyEvent keyEvent,
}) {
  print("here");
  if (keyEvent.logicalKey != LogicalKeyboardKey.enter) {
    return ExecutionInstruction.continueExecution;
  }

  final node = editContext.editor.document
      .getNodeById(editContext.composer.selection!.extent.nodeId);
  if (node is! TaskItemNode) {
    return ExecutionInstruction.continueExecution;
  }

  final didSplitTaskItem =
      editContext.commonOps.insertBlockLevelNewlineTask(editContext);
  return didSplitTaskItem
      ? ExecutionInstruction.haltExecution
      : ExecutionInstruction.continueExecution;
}

Widget? doneTaskItemBuilder(ComponentContext componentContext) {
  final taskItemNode = componentContext.documentNode;
  if (taskItemNode is! TaskItemNode) {
    return null;
  }

  if (taskItemNode.taskType != TaskItemType.done) {
    return null;
  }

  final textSelection =
      componentContext.nodeSelection?.nodeSelection as TextSelection?;
  final showCaret = componentContext.showCaret &&
      (componentContext.nodeSelection?.isExtent ?? false);

  return DoneTaskItemComponent(
    textKey: componentContext.componentKey,
    text: taskItemNode.text,
    styleBuilder: componentContext.extensions[textStylesExtensionKey],
    textSelection: textSelection,
    selectionColor: (componentContext.extensions[selectionStylesExtensionKey]
            as SelectionStyle)
        .selectionColor,
    showCaret: showCaret,
    caretColor: (componentContext.extensions[selectionStylesExtensionKey]
            as SelectionStyle)
        .textCaretColor,
  );
}

Widget? openTaskItemBuilder(ComponentContext componentContext) {
  final taskItemNode = componentContext.documentNode;
  if (taskItemNode is! TaskItemNode) {
    return null;
  }

  if (taskItemNode.taskType != TaskItemType.open) {
    return null;
  }

  DocumentNode? nodeAbove =
      componentContext.document.getNodeBefore(taskItemNode);
  while (nodeAbove != null &&
      nodeAbove is TaskItemNode &&
      nodeAbove.taskType == TaskItemType.open) {
    nodeAbove = componentContext.document.getNodeBefore(nodeAbove);
  }

  final textSelection =
      componentContext.nodeSelection?.nodeSelection as TextSelection?;
  final showCaret = componentContext.showCaret &&
      (componentContext.nodeSelection?.isExtent ?? false);

  return OpenTaskItemComponent(
    textKey: componentContext.componentKey,
    text: taskItemNode.text,
    styleBuilder: componentContext.extensions[textStylesExtensionKey],
    textSelection: textSelection,
    selectionColor: (componentContext.extensions[selectionStylesExtensionKey]
            as SelectionStyle)
        .selectionColor,
    showCaret: showCaret,
    caretColor: (componentContext.extensions[selectionStylesExtensionKey]
            as SelectionStyle)
        .textCaretColor,
  );
}

extension TaskAddition on CommonEditorOperations {
  bool insertBlockLevelNewlineTask(EditContext editContext) {
    if (editContext.composer.selection == null) {
      return false;
    }

    // Ensure that the entire selection sits within the same node.
    final baseNode = editContext.editor.document
        .getNodeById(editContext.composer.selection!.base.nodeId)!;
    final extentNode = editContext.editor.document
        .getNodeById(editContext.composer.selection!.extent.nodeId)!;
    if (baseNode.id != extentNode.id) {
      return false;
    }

    if (!editContext.composer.selection!.isCollapsed) {
      // The selection is not collapsed. Delete the selected content first,
      // then continue the process.
      deleteSelection();
    }

    final newNodeId = DocumentEditor.createNodeId();

    if (extentNode is TaskItemNode) {
      if (extentNode.text.text.isEmpty) {
        // The list item is empty. Convert it to a paragraph.
        return convertToParagraph();
      }

      // Split the list item into two.
      editContext.editor.executeCommand(
        SplitTaskItemCommand(
          nodeId: extentNode.id,
          splitPosition: editContext.composer.selection!.extent.nodePosition
              as TextNodePosition,
          newNodeId: newNodeId,
        ),
      );
    } else if (extentNode is ParagraphNode) {
      // Split the paragraph into two. This includes headers, blockquotes, and
      // any other block-level paragraph.
      final currentExtentPosition = editContext
          .composer.selection!.extent.nodePosition as TextNodePosition;
      final endOfParagraph = extentNode.endPosition;

      editContext.editor.executeCommand(
        SplitParagraphCommand(
          nodeId: extentNode.id,
          splitPosition: currentExtentPosition,
          newNodeId: newNodeId,
          replicateExistingMetdata:
              currentExtentPosition.offset != endOfParagraph.offset,
        ),
      );
    } else {
      // The selection extent might be an image, HR, etc. Insert a new
      // node after it.
      editContext.editor
          .executeCommand(EditorCommandFunction((doc, transaction) {
        transaction.insertNodeAfter(
          previousNode: extentNode,
          newNode: ParagraphNode(
            id: newNodeId,
            text: AttributedText(text: ''),
          ),
        );
      }));
    }

    // Place the caret at the beginning of the second node.
    editContext.composer.selection = DocumentSelection.collapsed(
      position: DocumentPosition(
        nodeId: newNodeId,
        nodePosition: TextNodePosition(offset: 0),
      ),
    );

    return true;
  }
}
