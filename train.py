import logging
import pandas as pd
from sklearn import datasets
from sklearn import svm

import bentoml

logging.basicConfig(level=logging.WARN)

if __name__ == "__main__":
    # Load training data
    file_path = "data/iris.csv"
    df = pd.read_csv(file_path)

    X, y = df.iloc[:, :-1].values , df.iloc[:, -1]

    # Model Training
    clf = svm.SVC()
    clf.fit(X, y)

    # Save model to BentoML local model store
    saved_model = bentoml.sklearn.save_model(
        "iris_clf", clf, signatures={"predict": {"batchable": True, "batch_dim": 0}}
    )
    print(f"Model saved: {saved_model}")


    iris_clf_runner = bentoml.sklearn.get("iris_clf:latest")
    print(f"model is saved on this path {iris_clf_runner.path}")