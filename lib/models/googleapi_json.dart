class BatchOp {
  BatchOp({
    this.pages,
    this.shardInfo,
    this.text,
    this.uri,
  });

  List<Page>? pages;
  ShardInfo? shardInfo;
  String? text;
  String? uri;

  BatchOp copyWith({
    List<Page>? pages,
    ShardInfo? shardInfo,
    String? text,
    String? uri,
  }) =>
      BatchOp(
        pages: pages ?? this.pages,
        shardInfo: shardInfo ?? this.shardInfo,
        text: text ?? this.text,
        uri: uri ?? this.uri,
      );

  factory BatchOp.fromMap(Map<String?, dynamic> json) => BatchOp(
        pages: json.containsKey("pages")
            ? List<Page>.from(json["pages"].map((x) => Page.fromMap(x)))
            : null,
        shardInfo: json.containsKey("shardInfo")
            ? ShardInfo.fromMap(json["shardInfo"])
            : null,
        text: json.containsKey('text') ? json['text'] as String : null,
        uri: json.containsKey('uri') ? json['uri'] as String : null,
      );

  /*Map<String?, dynamic> toMap() => {
        "pages": pages == null
            ? null
            : List<dynamic>.from(pages!.map((x) => x.toMap())),
        "shardInfo": shardInfo == null ? null : shardInfo!.toMap(),
        "text": text,
        "uri": uri,
      };*/
}

class Page {
  Page({
    this.blocks,
    this.detectedLanguages,
    this.dimension,
    this.image,
    this.layout,
    this.lines,
    this.pageNumber,
    this.paragraphs,
    this.tables,
    this.tokens,
  });

  List<Block>? blocks;
  List<DetectedLanguage>? detectedLanguages;
  Dimension? dimension;
  Image? image;
  PageLayout? layout;
  List<Line>? lines;
  int? pageNumber;
  List<Block>? paragraphs;
  List<Table>? tables;
  List<Token>? tokens;

  Page copyWith({
    List<Block>? blocks,
    List<DetectedLanguage>? detectedLanguages,
    Dimension? dimension,
    Image? image,
    PageLayout? layout,
    List<Line>? lines,
    int? pageNumber,
    List<Block>? paragraphs,
    List<Table>? tables,
    List<Token>? tokens,
  }) =>
      Page(
        blocks: blocks ?? this.blocks,
        detectedLanguages: detectedLanguages ?? this.detectedLanguages,
        dimension: dimension ?? this.dimension,
        image: image ?? this.image,
        layout: layout ?? this.layout,
        lines: lines ?? this.lines,
        pageNumber: pageNumber ?? this.pageNumber,
        paragraphs: paragraphs ?? this.paragraphs,
        tables: tables ?? this.tables,
        tokens: tokens ?? this.tokens,
      );

  factory Page.fromMap(Map<String, dynamic> json) => Page(
        blocks: json.containsKey("blocks")
            ? List<Block>.from(json["blocks"].map((x) => Block.fromMap(x)))
            : null,
        detectedLanguages: json.containsKey("detectedLanguages")
            ? List<DetectedLanguage>.from(json["detectedLanguages"]
                .map((x) => DetectedLanguage.fromMap(x)))
            : null,
        dimension: json.containsKey('dimension')
            ? Dimension.fromMap(json["dimension"])
            : null,
        image: json["image"] == null ? null : Image.fromMap(json["image"]),
        layout:
            json.containsKey('layout') ? PageLayout.fromMap(json["layout"]) : null,
        lines: json["lines"] == null
            ? null
            : List<Line>.from(json["lines"].map((x) => Line.fromMap(x))),
        pageNumber: json["pageNumber"],
        paragraphs: json["paragraphs"] == null
            ? null
            : List<Block>.from(json["paragraphs"].map((x) => Block.fromMap(x))),
        tables: json.containsKey('tables')
            ? List<Table>.from(json["tables"].map((x) => Table.fromMap(x)))
            : null,
        tokens: json["tokens"] == null
            ? null
            : List<Token>.from(json["tokens"].map((x) => Token.fromMap(x))),
      );

  /*Map<String?, dynamic> toMap() => {
        "blocks": blocks == null
            ? null
            : List<dynamic>.from(blocks!.map((x) => x.toMap())),
        "detectedLanguages": detectedLanguages == null
            ? null
            : List<dynamic>.from(detectedLanguages!.map((x) => x.toMap())),
        "dimension": dimension == null ? null : dimension!.toMap(),
        "image": image == null ? null : image!.toMap(),
        "layout": layout == null ? null : layout!.toMap(),
        "lines": lines == null
            ? null
            : List<dynamic>.from(lines!.map((x) => x.toMap())),
        "pageNumber": pageNumber,
        "paragraphs": paragraphs == null
            ? null
            : List<dynamic>.from(paragraphs!.map((x) => x.toMap())),
        "tables": tables == null
            ? null
            : List<dynamic>.from(tables!.map((x) => x.toMap())),
        "tokens": tokens == null
            ? null
            : List<dynamic>.from(tokens!.map((x) => x.toMap())),
      };*/
}

class Block {
  Block({
    this.layout,
  });

  BlockLayout? layout;

  Block copyWith({
    BlockLayout? layout,
  }) =>
      Block(
        layout: layout ?? this.layout,
      );

  factory Block.fromMap(Map<String?, dynamic> json) => Block(
        layout:
            json["layout"] == null ? null : BlockLayout.fromMap(json["layout"]),
      );

  Map<String?, dynamic> toMap() => {
        "layout": layout == null ? null : layout!.toMap(),
      };
}

class BlockLayout {
  BlockLayout({
    this.boundingPoly,
    this.confidence,
    this.orientation,
    this.textAnchor,
  });

  PurpleBoundingPoly? boundingPoly;
  double? confidence;
  Orientation? orientation;
  PurpleTextAnchor? textAnchor;

  BlockLayout copyWith({
    PurpleBoundingPoly? boundingPoly,
    double? confidence,
    Orientation? orientation,
    PurpleTextAnchor? textAnchor,
  }) =>
      BlockLayout(
        boundingPoly: boundingPoly ?? this.boundingPoly,
        confidence: confidence ?? this.confidence,
        orientation: orientation ?? this.orientation,
        textAnchor: textAnchor ?? this.textAnchor,
      );

  factory BlockLayout.fromMap(Map<String?, dynamic> json) => BlockLayout(
        boundingPoly: json["boundingPoly"] == null
            ? null
            : PurpleBoundingPoly.fromMap(json["boundingPoly"]),
        confidence:
            json["confidence"] == null ? null : json["confidence"].toDouble(),
        orientation: json["orientation"] == null
            ? null
            : orientationValues.map![json["orientation"]],
        textAnchor: json["textAnchor"] == null
            ? null
            : PurpleTextAnchor.fromMap(json["textAnchor"]),
      );

  Map<String?, dynamic> toMap() => {
        "boundingPoly": boundingPoly == null ? null : boundingPoly!.toMap(),
        "confidence": confidence,
        "orientation":
            orientation == null ? null : orientationValues.reverse[orientation],
        "textAnchor": textAnchor == null ? null : textAnchor!.toMap(),
      };
}

class PurpleBoundingPoly {
  PurpleBoundingPoly({
    this.normalizedVertices,
    this.vertices,
  });

  List<Vertex>? normalizedVertices;
  List<Vertex>? vertices;

  PurpleBoundingPoly copyWith({
    List<Vertex>? normalizedVertices,
    List<Vertex>? vertices,
  }) =>
      PurpleBoundingPoly(
        normalizedVertices: normalizedVertices ?? this.normalizedVertices,
        vertices: vertices ?? this.vertices,
      );

  factory PurpleBoundingPoly.fromMap(Map<String?, dynamic> json) =>
      PurpleBoundingPoly(
        normalizedVertices: json["normalizedVertices"] == null
            ? null
            : List<Vertex>.from(
                json["normalizedVertices"].map((x) => Vertex.fromMap(x))),
        vertices: json["vertices"] == null
            ? null
            : List<Vertex>.from(json["vertices"].map((x) => Vertex.fromMap(x))),
      );

  Map<String?, dynamic> toMap() => {
        "normalizedVertices": normalizedVertices == null
            ? null
            : List<dynamic>.from(normalizedVertices!.map((x) => x.toMap())),
        "vertices": vertices == null
            ? null
            : List<dynamic>.from(vertices!.map((x) => x.toMap())),
      };
}

class Vertex {
  Vertex({
    this.x,
    this.y,
  });

  double? x;
  double? y;

  Vertex copyWith({
    double? x,
    double? y,
  }) =>
      Vertex(
        x: x ?? this.x,
        y: y ?? this.y,
      );

  factory Vertex.fromMap(Map<String?, dynamic> json) => Vertex(
        x: json["x"] == null ? null : json["x"].toDouble(),
        y: json["y"] == null ? null : json["y"].toDouble(),
      );

  Map<String?, dynamic> toMap() => {
        "x": x,
        "y": y,
      };
}

enum Orientation { PAGE_UP }

final orientationValues = EnumValues({"PAGE_UP": Orientation.PAGE_UP});

class PurpleTextAnchor {
  List<PurpleTextSegment>? textSegments;

  PurpleTextAnchor({
    this.textSegments,
  });
  PurpleTextAnchor copyWith({
    List<PurpleTextSegment>? textSegments,
  }) =>
      PurpleTextAnchor(
        textSegments: textSegments ?? this.textSegments,
      );

  factory PurpleTextAnchor.fromMap(Map<String?, dynamic> json) =>
      PurpleTextAnchor(
        textSegments: json["textSegments"] == null
            ? null
            : List<PurpleTextSegment>.from(
                json["textSegments"].map((x) => PurpleTextSegment.fromMap(x))),
      );

  Map<String?, dynamic> toMap() => {
        "textSegments": textSegments == null
            ? null
            : List<dynamic>.from(textSegments!.map((x) => x.toMap())),
      };
}

class PurpleTextSegment {
  String? endIndex;
  String? startIndex;

  PurpleTextSegment({
    this.endIndex,
    this.startIndex,
  });

  PurpleTextSegment copyWith({
    String? endIndex,
    String? startIndex,
  }) =>
      PurpleTextSegment(
        endIndex: endIndex ?? this.endIndex,
        startIndex: startIndex ?? this.startIndex,
      );

  factory PurpleTextSegment.fromMap(Map<String?, dynamic> json) =>
      PurpleTextSegment(
        endIndex: json["endIndex"],
        startIndex: json["startIndex"],
      );

  Map<String?, dynamic> toMap() => {
        "endIndex": endIndex,
        "startIndex": startIndex,
      };
}

class DetectedLanguage {
  DetectedLanguage({
    this.languageCode,
  });

  LanguageCode? languageCode;

  DetectedLanguage copyWith({
    LanguageCode? languageCode,
  }) =>
      DetectedLanguage(
        languageCode: languageCode ?? this.languageCode,
      );

  factory DetectedLanguage.fromMap(Map<String?, dynamic> json) =>
      DetectedLanguage(
        languageCode: json["languageCode"] == null
            ? null
            : languageCodeValues.map![json["languageCode"]],
      );

  Map<String?, dynamic> toMap() => {
        "languageCode": languageCode == null
            ? null
            : languageCodeValues.reverse[languageCode],
      };
}

enum LanguageCode {
  UND,
  FR,
  EN,
  CO,
  ES,
  NL,
  ID,
  IG,
  IT,
  ILO,
  VI,
  ST,
  AF,
  BM,
  AK,
  NY,
  GD,
  NSO,
  PT
}

final languageCodeValues = EnumValues({
  "af": LanguageCode.AF,
  "ak": LanguageCode.AK,
  "bm": LanguageCode.BM,
  "co": LanguageCode.CO,
  "en": LanguageCode.EN,
  "es": LanguageCode.ES,
  "fr": LanguageCode.FR,
  "gd": LanguageCode.GD,
  "id": LanguageCode.ID,
  "ig": LanguageCode.IG,
  "ilo": LanguageCode.ILO,
  "it": LanguageCode.IT,
  "nl": LanguageCode.NL,
  "nso": LanguageCode.NSO,
  "ny": LanguageCode.NY,
  "pt": LanguageCode.PT,
  "st": LanguageCode.ST,
  "und": LanguageCode.UND,
  "vi": LanguageCode.VI
});

class Dimension {
  Dimension({
    this.height,
    this.unit,
    this.width,
  });

  int? height;
  String? unit;
  int? width;

  Dimension copyWith({
    int? height,
    String? unit,
    int? width,
  }) =>
      Dimension(
        height: height ?? this.height,
        unit: unit ?? this.unit,
        width: width ?? this.width,
      );

  factory Dimension.fromMap(Map<String?, dynamic> json) => Dimension(
        height: json["height"],
        unit: json["unit"],
        width: json["width"],
      );

  Map<String?, dynamic> toMap() => {
        "height": height,
        "unit": unit,
        "width": width,
      };
}

class Image {
  Image({
    this.content,
    this.height,
    this.width,
  });

  String? content;
  int? height;
  int? width;

  Image copyWith({
    String? content,
    int? height,
    int? width,
  }) =>
      Image(
        content: content ?? this.content,
        height: height ?? this.height,
        width: width ?? this.width,
      );

  factory Image.fromMap(Map<String?, dynamic> json) => Image(
        content: json["content"],
        height: json["height"],
        width: json["width"],
      );

  Map<String?, dynamic> toMap() => {
        "content": content,
        "height": height,
        "width": width,
      };
}

class PageLayout {
  PageLayout({
    this.boundingPoly,
    this.orientation,
    this.textAnchor,
  });

  PurpleBoundingPoly? boundingPoly;
  Orientation? orientation;
  FluffyTextAnchor? textAnchor;

  PageLayout copyWith({
    PurpleBoundingPoly? boundingPoly,
    Orientation? orientation,
    FluffyTextAnchor? textAnchor,
  }) =>
      PageLayout(
        boundingPoly: boundingPoly ?? this.boundingPoly,
        orientation: orientation ?? this.orientation,
        textAnchor: textAnchor ?? this.textAnchor,
      );

  factory PageLayout.fromMap(Map<String?, dynamic> json) => PageLayout(
        boundingPoly: json["boundingPoly"] == null
            ? null
            : PurpleBoundingPoly.fromMap(json["boundingPoly"]),
        orientation: json["orientation"] == null
            ? null
            : orientationValues.map![json["orientation"]],
        textAnchor: json["textAnchor"] == null
            ? null
            : FluffyTextAnchor.fromMap(json["textAnchor"]),
      );

  Map<String?, dynamic> toMap() => {
        "boundingPoly": boundingPoly == null ? null : boundingPoly!.toMap(),
        "orientation":
            orientation == null ? null : orientationValues.reverse[orientation],
        "textAnchor": textAnchor == null ? null : textAnchor!.toMap(),
      };
}

class FluffyTextAnchor {
  FluffyTextAnchor({
    this.textSegments,
  });

  List<FluffyTextSegment>? textSegments;

  FluffyTextAnchor copyWith({
    List<FluffyTextSegment>? textSegments,
  }) =>
      FluffyTextAnchor(
        textSegments: textSegments ?? this.textSegments,
      );

  factory FluffyTextAnchor.fromMap(Map<String?, dynamic> json) =>
      FluffyTextAnchor(
        textSegments: json["textSegments"] == null
            ? null
            : List<FluffyTextSegment>.from(
                json["textSegments"].map((x) => FluffyTextSegment.fromMap(x))),
      );

  Map<String?, dynamic> toMap() => {
        "textSegments": textSegments == null
            ? null
            : List<dynamic>.from(textSegments!.map((x) => x.toMap())),
      };
}

class FluffyTextSegment {
  FluffyTextSegment({
    this.endIndex,
  });

  String? endIndex;

  FluffyTextSegment copyWith({
    String? endIndex,
  }) =>
      FluffyTextSegment(
        endIndex: endIndex ?? this.endIndex,
      );

  factory FluffyTextSegment.fromMap(Map<String?, dynamic> json) =>
      FluffyTextSegment(
        endIndex: json["endIndex"],
      );

  Map<String?, dynamic> toMap() => {
        "endIndex": endIndex,
      };
}

class Line {
  Line({
    this.detectedLanguages,
    this.layout,
  });

  List<DetectedLanguage>? detectedLanguages;
  BlockLayout? layout;

  Line copyWith({
    List<DetectedLanguage>? detectedLanguages,
    BlockLayout? layout,
  }) =>
      Line(
        detectedLanguages: detectedLanguages ?? this.detectedLanguages,
        layout: layout ?? this.layout,
      );

  factory Line.fromMap(Map<String?, dynamic> json) => Line(
        detectedLanguages: json["detectedLanguages"] == null
            ? null
            : List<DetectedLanguage>.from(json["detectedLanguages"]
                .map((x) => DetectedLanguage.fromMap(x))),
        layout:
            json["layout"] == null ? null : BlockLayout.fromMap(json["layout"]),
      );

  Map<String?, dynamic> toMap() => {
        "detectedLanguages": detectedLanguages == null
            ? null
            : List<dynamic>.from(detectedLanguages!.map((x) => x.toMap())),
        "layout": layout == null ? null : layout!.toMap(),
      };
}

class Table {
  Table({
    this.bodyRows,
    this.headerRows,
    this.layout,
  });

  List<Row>? bodyRows;
  List<Row>? headerRows;
  CellLayout? layout;

  Table copyWith({
    List<Row>? bodyRows,
    List<Row>? headerRows,
    CellLayout? layout,
  }) =>
      Table(
        bodyRows: bodyRows ?? this.bodyRows,
        headerRows: headerRows ?? this.headerRows,
        layout: layout ?? this.layout,
      );

  factory Table.fromMap(Map<String?, dynamic> json) => Table(
        bodyRows: json.containsKey('bodyRows')
            ? List<Row>.from(json["bodyRows"].map((x) => Row.fromMap(x)))
            : null,
        headerRows: json["headerRows"] == null
            ? null
            : List<Row>.from(json["headerRows"].map((x) => Row.fromMap(x))),
        layout:
            json["layout"] == null ? null : CellLayout.fromMap(json["layout"]),
      );

  Map<String?, dynamic> toMap() => {
        "bodyRows": bodyRows == null
            ? null
            : List<dynamic>.from(bodyRows!.map((x) => x.toMap())),
        "headerRows": headerRows == null
            ? null
            : List<dynamic>.from(headerRows!.map((x) => x.toMap())),
        "layout": layout == null ? null : layout!.toMap(),
      };
}

class Row {
  Row({
    this.cells,
  });

  List<Cell>? cells;

  Row copyWith({
    List<Cell>? cells,
  }) =>
      Row(
        cells: cells ?? this.cells,
      );

  factory Row.fromMap(Map<String?, dynamic> json) => Row(
        cells: json["cells"] == null
            ? null
            : List<Cell>.from(json["cells"].map((x) => Cell.fromMap(x))),
      );

  Map<String?, dynamic> toMap() => {
        "cells": cells == null
            ? null
            : List<dynamic>.from(cells!.map((x) => x.toMap())),
      };
}

class Cell {
  Cell({
    this.colSpan,
    this.layout,
    this.rowSpan,
  });

  int? colSpan;
  CellLayout? layout;
  int? rowSpan;

  Cell copyWith({
    int? colSpan,
    CellLayout? layout,
    int? rowSpan,
  }) =>
      Cell(
        colSpan: colSpan ?? this.colSpan,
        layout: layout ?? this.layout,
        rowSpan: rowSpan ?? this.rowSpan,
      );

  factory Cell.fromMap(Map<String?, dynamic> json) => Cell(
        colSpan: json["colSpan"],
        layout:
            json["layout"] == null ? null : CellLayout.fromMap(json["layout"]),
        rowSpan: json["rowSpan"],
      );

  Map<String?, dynamic> toMap() => {
        "colSpan": colSpan,
        "layout": layout == null ? null : layout!.toMap(),
        "rowSpan": rowSpan,
      };
}

class CellLayout {
  CellLayout({
    this.boundingPoly,
    this.confidence,
    this.orientation,
    this.textAnchor,
  });

  FluffyBoundingPoly? boundingPoly;
  double? confidence;
  Orientation? orientation;
  PurpleTextAnchor? textAnchor;

  CellLayout copyWith({
    FluffyBoundingPoly? boundingPoly,
    double? confidence,
    Orientation? orientation,
    PurpleTextAnchor? textAnchor,
  }) =>
      CellLayout(
        boundingPoly: boundingPoly ?? this.boundingPoly,
        confidence: confidence ?? this.confidence,
        orientation: orientation ?? this.orientation,
        textAnchor: textAnchor ?? this.textAnchor,
      );

  factory CellLayout.fromMap(Map<String?, dynamic> json) => CellLayout(
        boundingPoly: json["boundingPoly"] == null
            ? null
            : FluffyBoundingPoly.fromMap(json["boundingPoly"]),
        confidence:
            json["confidence"] == null ? null : json["confidence"].toDouble(),
        orientation: json["orientation"] == null
            ? null
            : orientationValues.map![json["orientation"]],
        textAnchor: json["textAnchor"] == null
            ? null
            : PurpleTextAnchor.fromMap(json["textAnchor"]),
      );

  Map<String?, dynamic> toMap() => {
        "boundingPoly": boundingPoly == null ? null : boundingPoly!.toMap(),
        "confidence": confidence,
        "orientation":
            orientation == null ? null : orientationValues.reverse[orientation],
        "textAnchor": textAnchor == null ? null : textAnchor!.toMap(),
      };
}

class FluffyBoundingPoly {
  FluffyBoundingPoly({
    this.normalizedVertices,
  });

  List<Vertex>? normalizedVertices;

  FluffyBoundingPoly copyWith({
    List<Vertex>? normalizedVertices,
  }) =>
      FluffyBoundingPoly(
        normalizedVertices: normalizedVertices ?? this.normalizedVertices,
      );

  factory FluffyBoundingPoly.fromMap(Map<String?, dynamic> json) =>
      FluffyBoundingPoly(
        normalizedVertices: json["normalizedVertices"] == null
            ? null
            : List<Vertex>.from(
                json["normalizedVertices"].map((x) => Vertex.fromMap(x))),
      );

  Map<String?, dynamic> toMap() => {
        "normalizedVertices": normalizedVertices == null
            ? null
            : List<dynamic>.from(normalizedVertices!.map((x) => x.toMap())),
      };
}

class Token {
  Token({
    this.detectedBreak,
    this.detectedLanguages,
    this.layout,
  });

  DetectedBreak? detectedBreak;
  List<DetectedLanguage>? detectedLanguages;
  BlockLayout? layout;

  Token copyWith({
    DetectedBreak? detectedBreak,
    List<DetectedLanguage>? detectedLanguages,
    BlockLayout? layout,
  }) =>
      Token(
        detectedBreak: detectedBreak ?? this.detectedBreak,
        detectedLanguages: detectedLanguages ?? this.detectedLanguages,
        layout: layout ?? this.layout,
      );

  factory Token.fromMap(Map<String?, dynamic> json) => Token(
        detectedBreak: json["detectedBreak"] == null
            ? null
            : DetectedBreak.fromMap(json["detectedBreak"]),
        detectedLanguages: json["detectedLanguages"] == null
            ? null
            : List<DetectedLanguage>.from(json["detectedLanguages"]
                .map((x) => DetectedLanguage.fromMap(x))),
        layout:
            json["layout"] == null ? null : BlockLayout.fromMap(json["layout"]),
      );

  Map<String?, dynamic> toMap() => {
        "detectedBreak": detectedBreak == null ? null : detectedBreak!.toMap(),
        "detectedLanguages": detectedLanguages == null
            ? null
            : List<dynamic>.from(detectedLanguages!.map((x) => x.toMap())),
        "layout": layout == null ? null : layout!.toMap(),
      };
}

class DetectedBreak {
  DetectedBreak({
    this.type,
  });

  Type? type;

  DetectedBreak copyWith({
    Type? type,
  }) =>
      DetectedBreak(
        type: type ?? this.type,
      );

  factory DetectedBreak.fromMap(Map<String?, dynamic> json) => DetectedBreak(
        type: json["type"] == null ? null : typeValues.map![json["type"]],
      );

  Map<String?, dynamic> toMap() => {
        "type": type == null ? null : typeValues.reverse[type],
      };
}

enum Type { SPACE }

final typeValues = EnumValues({"SPACE": Type.SPACE});

class ShardInfo {
  ShardInfo({
    this.shardCount,
  });

  String? shardCount;

  ShardInfo copyWith({
    String? shardCount,
  }) =>
      ShardInfo(
        shardCount: shardCount ?? this.shardCount,
      );

  factory ShardInfo.fromMap(Map<String?, dynamic> json) => ShardInfo(
        shardCount: json["shardCount"],
      );

  Map<String?, dynamic> toMap() => {
        "shardCount": shardCount,
      };
}

class EnumValues<T> {
  Map<String?, T>? map;
  Map<T, String?>? reverseMap;

  EnumValues(this.map);

  Map<T, String?> get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}
