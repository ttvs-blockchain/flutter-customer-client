import yaml

with open("pubspec.yaml", "r") as f:
    try:
        yaml_content = yaml.safe_load(f)
        print("v" + yaml_content["version"])
    except yaml.YAMLError as exc:
        print(exc)
