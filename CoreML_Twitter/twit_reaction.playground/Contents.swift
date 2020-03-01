import Cocoa
import CreateML

let data = try MLDataTable(contentsOf: URL(fileURLWithPath: "/Users/mlatt/Desktop/Folders/ios_App_Folder/CoreML_Twitter/twitter-sanders-apple3.csv"))

let(trainingDate, testingData) = data.randomSplit(by: 0.8, seed: 5)

let sentimentClassifier = try MLTextClassifier(trainingData: trainingDate, textColumn: "text", labelColumn: "class")

let evaluationMetric = sentimentClassifier.evaluation(on: testingData)

let evaluationAccuracy = (1.0 - evaluationMetric.classificationError) * 100

let metaData = MLModelMetadata(author: "Moe Latt", shortDescription: "A model train to classify sentiment on tweets", version: "1.0")

try sentimentClassifier.write(to: URL(fileURLWithPath: "/Users/mlatt/Desktop/Folders/ios_App_Folder/CoreML_Twitter/TweetSentimentClassifier.mlmodel"))

try sentimentClassifier.prediction(from: "@Apple is normal company")
