# cloudpods-operator

<https://github.com/yunionio/cloudpods-operator>

```bash
git remote add upstream git@github.com:yunionio/cloudpods-operator.git

git fetch upstream

git merge v3.11.12
```

## build

```bash
# golang build
docker run -it --rm \
  -v $PWD/:/go/src/github.com/yunionio/cloudpods-operator \
  -w /go/src/github.com/yunionio/cloudpods-operator \
  -e VERSION=v3.11.12 \
  registry.cn-qingdao.aliyuncs.com/wod/golang:1.24-alpine \
  bash .beagle/build.sh
```
