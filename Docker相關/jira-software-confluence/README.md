# intro
使用docker運行jira-software以及confluence

# 調整JIRA使用效能
- 調整初始化最小記憶體使用量
> JVM_MINIMUM_MEMORY: 2048m

- 調整最大記憶體使用量
> JVM_MAXIMUM_MEMORY: 4096m

- 調整CPU使用緩存大小
> JVM_RESERVED_CODE_CACHE_SIZE: 1024m


# refer:
### docker run jira
- https://hub.docker.com/r/atlassian/jira-software

### docker run confluence
- https://hub.docker.com/r/atlassian/confluence-server/

### jvm related
- https://www.itread01.com/content/1548983167.html
- https://www.itread01.com/content/1550322003.html