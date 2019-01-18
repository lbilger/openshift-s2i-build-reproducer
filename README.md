# openshift-s2i-build-reproducer

Simple example to reproduce a problem with the Java S2I image in OpenShift.

## Starting a BuildConfig with binary input fails when `ARTIFACT_DIR` is set, e.g. for multi-module maven projects

To reproduce, log in to an OpenShift cluster and a namespace where you have edit privileges, then call the following scripts:
- `create-build.sh` - Create a build for this repository and set the `ARTIFACT_DIR` environment variable to get the jar from `impl/target`
- `start-source-build.sh` - Run a source build - build will succeed
- `start-binary-build.sh` - Run a binary build - build will fail with error message `Aborting due to error code 1 for copying impl/target to /deployments`
- `delete-build.sh` - Clean up by deleting the build config and image stream that were previously created

The failure in the binary build is due to the `ARTIFACT_DIR` not being prefixed with the `S2I_SOURCE_DIR` and thus being interpreted as a path relative to `/home/jboss`.

Suggested fix: Change line 183 of the `assemble` script from
```bash
  binary_dir="${ARTIFACT_DIR:-${default_binary_dir}}"
```
to
```bash
  binary_dir="${ARTIFACT_DIR+${S2I_SOURCE_DIR}/}${ARTIFACT_DIR:-${default_binary_dir}}"
```

Note that setting an absolute path in `ARTIFACT_DIR` does not work because of the following code in lines 41-44 of the `assemble` script:
```bash
    if [ "${ARTIFACT_DIR:0:1}" = "/" ]; then
       echo "ARTIFACT_DIR \"${ARTIFACT_DIR}\" must not be absolute but relative to the source directory"
       exit 1
    fi
```
