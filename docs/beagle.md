# Beagle 变更记录

## 变更 1: 支持非 OneCloud 命名空间

### 变更时间

2026-01-05

### 变更说明

Operator 支持在任意命名空间部署 OnecloudCluster，不再限制于固定的 `onecloud` 命名空间。OnecloudCluster 资源在哪个命名空间创建，相关的 Deployment、Service、ConfigMap 等资源就会在该命名空间中创建。

### 变更文件

- `pkg/manager/component/component.go` - 组件管理器使用 `oc.GetNamespace()` 获取命名空间
- `pkg/manager/config/config.go` - 配置管理器使用 `oc.GetNamespace()` 获取命名空间
- `pkg/manager/certs/manager.go` - 证书管理器使用 `oc.GetNamespace()` 获取命名空间
- `pkg/manager/component/etcd.go` - Etcd 组件使用 `oc.GetNamespace()` 获取命名空间
- `pkg/controller/*.go` - 控制器层使用动态命名空间

### 业务逻辑

所有组件在创建 Kubernetes 资源时，通过 `oc.GetNamespace()` 方法动态获取 OnecloudCluster 所在的命名空间，而不是使用硬编码的命名空间值。

---

## 变更 2: Image 字段禁止被覆盖

### 变更时间

2026-01-05

### 变更说明

当用户在 CRD 中显式设置了组件的 `image` 字段时，Operator 不再覆盖该值。用户可以直接指定完整的镜像地址（如 `registry.example.com/myrepo:tag`），Operator 会尊重用户的设置。

### 变更文件

- `pkg/apis/onecloud/v1alpha1/defaults.go`

### 业务逻辑

在以下函数中增加条件判断，只有当 `obj.Image` 为空时才设置默认值：

- `SetDefaults_DeploymentSpec` - Deployment 类型组件
- `SetDefaults_DaemonSetSpec` - DaemonSet 类型组件
- `SetDefaults_CronJobSpec` - CronJob 类型组件
- 各个组件的 Image 直接赋值处（Web.Overview、Web.Docs、Webconsole.Guacd、HostAgent.SdnAgent、HostAgent.OvnController、OvnNorth、HostImage、HostAgent.HostHealth、Lbagent.OvnController、Telegraf.TelegrafRaid、Notify.Plugins 等）

修改前：Operator 会无条件使用 `repository/imageName:tag` 格式覆盖 Image 字段。

修改后：如果用户设置了 Image 字段，Operator 保持用户设置不变；如果 Image 为空，则使用默认的拼接逻辑生成镜像地址。
