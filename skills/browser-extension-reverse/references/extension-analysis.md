# Extension Analysis Highlights

| Field | Risk Signal |
|------|----------|
| host_permissions `<all_urls>` | Can read and write any site |
| webRequestBlocking | Man-in-the-middle style rewriting |
| nativeMessaging | Communication out of the browser to the local machine |
| externally_connectable | Web pages can drive the extension |

MV3: focus on the service_worker lifecycle and declarativeNetRequest.
