# Featured files

## Daemon
- pkg/controller/daemon/daemonset_controller.go
- pkg/controller/daemon/util/daemonset_util.go

## ControllerManager
- cmd/kube-controller-manager/app/controllermanager.go

## **Node lifecycle controller**
- cmd/kube-controller-manager/app/core.go
  - func startNodeLifecycleController(...)
- pkg/controller/nodelifecycle/node_lifecycle_controller.go
  - func NewNodeLifecycleController(...)
    - **// NewNodeLifecycleController returns a new taint controller.**

## **Taint manager**
- pkg/controller/nodelifecycle/scheduler/taint_manager.go
  - type **NoExecuteTaintManager** struct {...}
    - // NoExecuteTaintManager listens to Taint/Toleration changes and is responsible for removing Pods from Nodes tainted with NoExecute Taints.
  - func NewNoExecuteTaintManager(...)

## Taint utility
  - kubernetes/pkg/util/taints/taints.go

## Kubelet related to taint
- pkg/kubelet/kubelet_node_status.go
  - initialNode(...)

## Kubelet
- pkg/kubelet/kubelet.go
  - NewMainKubelet(..., registerWithTaints []v1.Taint, ...)
- cmd/kubelet/app/server.go
  - CreateAndInitKubelet() -> NewmainKubelet()
- server.go/createAndInitKubelet -> kubelet.go/NewMainKubelet -> kubelet.go/makePodSourceConfig -> NewSourceApiserver
- runonce.go/run -> runonce.go/RunKubelet -> runonce.go/RunOnce -> runonce.go/kl.runOnce -> runonce.go/kl.runPod -> kubelet.go/SyncPod ->
- runonce.go/run -> runonce.go/RunKubelet -> runonce.go/startKubelet -> kubelet.go/Run -> kubelet.go/syncLoop -> kubelet.go/syncLoopIteration -> HandlePodAdditions, HandlePodUpdates or ... 
  - HandlePodAdditions (HandlePodAdditions is the callback in SyncHandler for pods being added from a config source.) -> podManager.AddPod, canAdmitPod, UpdatePod -> 

## Extra
- TolerationSeconds
    // TolerationSeconds represents the period of time the toleration (which must be
    // of effect NoExecute, otherwise this field is ignored) tolerates the taint. By default,
    // it is not set, which means tolerate the taint forever (do not evict). Zero and
    // negative values will be treated as 0 (evict immediately) by the system.
    // +optional
    TolerationSeconds *int64 `json:"tolerationSeconds,omitempty" protobuf:"varint,5,opt,name=tolerationSeconds"`


# Descheduler
For the failure cases which were successfully reproduced, two plugins lie in our interest. 
1. RemoveDuplicates
2. RemovePOdsViolatingTopologySpreadConstraint

## 2023-07-08
- RemoveDuplicate
  - ownerreflist == 0 ? what does it mean? if a pod is owned by itself, is it supposed to return 0 of len(ownerreflist)?
  - 


## Related files
- pkg
  - descheduler
    - descheduler_test.go
      - func TestDeuplicate
  - framework
    - plugins
      - **removeduplicates**
        - removeduplicates.go
          - New()
          - **Balance()** (actual implementation)
            - arg: nodes
            1. It iterates nodes one by one using for loop. (for _, node := range nodes)
            2. Find all **pods** in the node after applying given podFilter. (ListPodsOnANode)
               1. Iterate pods belonging to the node one by one
                  1. 
            3. OwnerRef/Image is used as a key to define the uniqueness of all pod. If there are more than two pods having the exactly same key of ownerref/image, then they are **duplicates**.
               - Two possible reasons of duplicates
                 - The 2 pods have the exact same ownerrefs
                 - The 2 pods have the exact same container images
        - removeduplicates_test.go
      - **removepodsviolatingtopologyspreadconstraint**


# Overall flow
1. descheduler.go/Run
   1. descheduler.go/RunDeschedulerStrategies
      1. descheduler.go/NonSlidingUntil
         1. get all ready nodes (ReadyNodes)
         2. descheduler.go/ Create evictor object (podEvictor := evictions.NewPodEvictor)
         3. descheduler.go/ Create evictions.NewPodEvictor object
         4. descheduler.go/ Call currProfile.RunDeschedulePlugins(ctx, nodes)
            1. profile.go/RunDeschedulePlugins
               1. profile.go/pl.Deschedule(childCtx, nodes)
         5. descheduler.go/ Call currProfile.RunBalancePlugins(ctx, nodes)
            1. profile.go/RunBalancePlugins
               1. profile.go//pl.Balance(childCtx, nodes)
                  1. *removeduplicates.go/Balance()
                    1. for loop each node
                      1. for loop pods in the node
                        1. for loop images in the pod
                          1. ownerRefList := Get OwnerRef List of the pod
                          2. get imageList from containerList of the pod
                          3. // I don't understand key matching part
                          4. Anyway if it finds a pod having the same key as one we saw previously, add it to duplicatePods data structure(dictionary)
                          5. ***any non-unique Namespace/Kind/Name/Image pattern is a duplicate pod.
                     2. for node having the duplicate pods which is duplicatePods data structure.
                        1. // 1. how many pods can be evicted to respect uniform placement of pods among viable nodes?
                        2. get targetnodes := getTargetNodes(podNodes, nodes) ??
                        3. if len(targetNodes) < 2 {klog.V(1).InfoS("Less than two feasible nodes for duplicates to land, skipping eviction", "owner", ownerKey), continue
                           1. In other words, two number of nodes for a particular pod is minimum for maybe fault tolerance.
                        4. I don't understand upperAvg line
                        5. for pod in the node (these pods are actually duplicate pods in the node)
                           1. It's assumed all duplicated pods are in the same priority class
                           2. for pod in the same group of duplicate pods (actual duplicates)
                              1. types.go/Evictor().Evict() -> fake.go/Evict()->evictions.go/EvictPod()
                                 1. if NodeLimitExceeded then done with this node // NodeLimitExceeded checks if the number of evictions for a node was exceeded
                  2. *topologyspreadconstraint.go/Balance()
      2. Sleep for a certain interval and repeat the loop


### Plugin order
descheduler.go
- deschedulerPolicy, err := LoadPolicyConfig(rs.PolicyConfigFile, rs.Client, pluginregistry.**PluginRegistry**)
  - **policyconfig.go**
    - func LoadPolicyConfig(policyConfigFile string, client clientset.Interface, registry pluginregistry.Registry) (*api.DeschedulerPolicy, error)
 - **pluginregistry.go**
   - var **PluginRegistry** **Registry**
   - func **Register**

- app/options/options.go
```go
// NewDeschedulerServer creates a new DeschedulerServer with default parameters
func NewDeschedulerServer() (*DeschedulerServer, error) {
	cfg, err := newDefaultComponentConfig()
	if err != nil {
		return nil, err
	}

	secureServing := apiserveroptions.**NewSecureServingOptions**().WithLoopback()
	secureServing.BindPort = DefaultDeschedulerPort

	return &DeschedulerServer{
		DeschedulerConfiguration: *cfg,
		SecureServing:            secureServing,
	}, nil
}
```

- OwnerReference: types.go, line 291
  - APIVersion
  - Kind
  - Name
  - UID
  - Controller
  - BlockOwnerDeletion

evictions.go
PodEvictor
NewPodEvictor
TotalEvicted: # total evicted pod by podevictor
OwnerRef
OwnerReferences in types.go
```go
// List of objects depended by this object. If ALL objects in the list have
// been deleted, this object will be garbage collected. If this object is managed by a controller,
// then an entry in this list will point to this controller, with the controller field set to true.
// There cannot be more than one managing controller.
// +optional
// +patchMergeKey=uid
// +patchStrategy=merge
OwnerReferences []OwnerReference `json:"ownerReferences,omitempty" patchStrategy:"merge" patchMergeKey:"uid" protobuf:"bytes,13,rep,name=ownerReferences"`
```
Filter
PreEvictionFiler


pods.go
```go
// GetPodsAssignedToNodeFunc is a function which accept a node name and a pod filter function
// as input and returns the pods that assigned to the node.
type GetPodsAssignedToNodeFunc func(string, FilterFunc) ([]*v1.Pod, error)
```

```go
// ListPodsOnANode lists all pods on a node.
// It also accepts a "filter" function which can be used to further limit the pods that are returned.
// (Usually this is podEvictor.Evictable().IsEvictable, in order to only list the evictable pods on a node, but can
// be used by strategies to extend it if there are further restrictions, such as with NodeAffinity).
func ListPodsOnANode(
	nodeName string,
	getPodsAssignedToNode GetPodsAssignedToNodeFunc,
	filter FilterFunc,
) ([]*v1.Pod, error) {
	// Succeeded and failed pods are not considered because they don't occupy any resource.
	f := func(pod *v1.Pod) bool {
		return pod.Status.Phase != v1.PodSucceeded && pod.Status.Phase != v1.PodFailed
	}
	return ListAllPodsOnANode(nodeName, getPodsAssignedToNode, WrapFilterFuncs(f, filter))
}
```

types.go
```go
// Evictor defines an interface for filtering and evicting pods
// while abstracting away the specific pod evictor/evictor filter.
type Evictor interface {
	// Filter checks if a pod can be evicted
	Filter(*v1.Pod) bool
	// PreEvictionFilter checks if pod can be evicted right before eviction
	PreEvictionFilter(*v1.Pod) bool
	// Evict evicts a pod (no pre-check performed)
	Evict(context.Context, *v1.Pod, evictions.EvictOptions) bool
	// NodeLimitExceeded checks if the number of evictions for a node was exceeded
	NodeLimitExceeded(node *v1.Node) bool
}
```