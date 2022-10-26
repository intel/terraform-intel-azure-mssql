{
    "lenses": {
      "0": {
        "order": 0,
        "parts": {
          "0": {
            "position": {
              "x": 0,
              "y": 0,
              "colSpan": 6,
              "rowSpan": 3
            },
            "metadata": {
              "inputs": [
                {
                  "name": "sharedTimeRange",
                  "isOptional": true
                },
                {
                  "name": "options",
                  "value": {
                    "chart": {
                      "metrics": [
                        {
                          "aggregationType": 4,
                          "metricVisualization": {
                            "displayName": "Percentage CPU"
                          },
                          "name": "Percentage CPU",
                          "namespace": "microsoft.compute/virtualmachines",
                          "resourceMetadata": {
                            "id": "${vmid}"
                          }
                        }
                      ],
                      "timespan": {
                        "grain": 1,
                        "relative": {
                          "duration": 1800000
                        },
                        "showUTCTime": false
                      },
                      "title": "Average Percentage CPU for ${vmname}",
                      "titleKind": 1,
                      "visualization": {
                        "axisVisualization": {
                          "x": {
                            "axisType": 2,
                            "isVisible": true
                          },
                          "y": {
                            "axisType": 1,
                            "isVisible": true
                          }
                        },
                        "chartType": 2,
                        "legendVisualization": {
                          "hideSubtitle": false,
                          "isVisible": true,
                          "position": 2
                        }
                      }
                    }
                  },
                  "isOptional": true
                }
              ],
              "type": "Extension/HubsExtension/PartType/MonitorChartPart",
              "settings": {
                "content": {
                  "options": {
                    "chart": {
                      "metrics": [
                        {
                          "aggregationType": 4,
                          "metricVisualization": {
                            "displayName": "Percentage CPU"
                          },
                          "name": "Percentage CPU",
                          "namespace": "microsoft.compute/virtualmachines",
                          "resourceMetadata": {
                            "id": "${vmid}"
                          }
                        }
                      ],
                      "title": "Average CPU Percentage for ${vmname}",
                      "titleKind": 2,
                      "visualization": {
                        "axisVisualization": {
                          "x": {
                            "axisType": 2,
                            "isVisible": true
                          },
                          "y": {
                            "axisType": 1,
                            "isVisible": true
                          }
                        },
                        "chartType": 2,
                        "disablePinning": true,
                        "legendVisualization": {
                          "hideSubtitle": false,
                          "isVisible": true,
                          "position": 2
                        }
                      }
                    }
                  }
                }
              }
            }
          },
          "1": {
            "position": {
              "x": 6,
              "y": 0,
              "colSpan": 6,
              "rowSpan": 3
            },
            "metadata": {
              "inputs": [
                {
                  "name": "sharedTimeRange",
                  "isOptional": true
                },
                {
                  "name": "options",
                  "value": {
                    "chart": {
                      "metrics": [
                        {
                          "aggregationType": 4,
                          "metricVisualization": {
                            "displayName": "Data Disk Queue Depth (Preview)"
                          },
                          "name": "Data Disk Queue Depth",
                          "namespace": "microsoft.compute/virtualmachines",
                          "resourceMetadata": {
                            "id": "${vmid}"
                          }
                        }
                      ],
                      "timespan": {
                        "grain": 1,
                        "relative": {
                          "duration": 86400000
                        },
                        "showUTCTime": false
                      },
                      "title": "Average Data Disk Queue Depth (Preview) for ${vmname}",
                      "titleKind": 1,
                      "visualization": {
                        "axisVisualization": {
                          "x": {
                            "axisType": 2,
                            "isVisible": true
                          },
                          "y": {
                            "axisType": 1,
                            "isVisible": true
                          }
                        },
                        "chartType": 2,
                        "legendVisualization": {
                          "hideSubtitle": false,
                          "isVisible": true,
                          "position": 2
                        }
                      }
                    }
                  },
                  "isOptional": true
                }
              ],
              "type": "Extension/HubsExtension/PartType/MonitorChartPart",
              "settings": {
                "content": {
                  "options": {
                    "chart": {
                      "metrics": [
                        {
                          "aggregationType": 4,
                          "metricVisualization": {
                            "displayName": "OS Disk Queue Depth (Preview)"
                          },
                          "name": "OS Disk Queue Depth",
                          "namespace": "microsoft.compute/virtualmachines",
                          "resourceMetadata": {
                            "id": "${vmid}"
                          }
                        }
                      ],
                      "title": "Average Queue Depths for ${vmname} Disks",
                      "titleKind": 2,
                      "visualization": {
                        "axisVisualization": {
                          "x": {
                            "axisType": 2,
                            "isVisible": true
                          },
                          "y": {
                            "axisType": 1,
                            "isVisible": true
                          }
                        },
                        "chartType": 2,
                        "disablePinning": true,
                        "legendVisualization": {
                          "hideSubtitle": false,
                          "isVisible": true,
                          "position": 2
                        }
                      }
                    }
                  }
                }
              }
            }
          },
          "2": {
            "position": {
              "x": 0,
              "y": 3,
              "colSpan": 6,
              "rowSpan": 3
            },
            "metadata": {
              "inputs": [
                {
                  "name": "options",
                  "isOptional": true
                },
                {
                  "name": "sharedTimeRange",
                  "isOptional": true
                }
              ],
              "type": "Extension/HubsExtension/PartType/MonitorChartPart",
              "settings": {
                "content": {
                  "options": {
                    "chart": {
                      "metrics": [
                        {
                          "aggregationType": 4,
                          "metricVisualization": {
                            "displayName": "OS Disk IOPS Consumed Percentage",
                            "resourceDisplayName": "${vmname}"
                          },
                          "name": "OS Disk IOPS Consumed Percentage",
                          "namespace": "microsoft.compute/virtualmachines",
                          "resourceMetadata": {
                            "id": "${vmid}"
                          }
                        }
                      ],
                      "title": "OS Disk IOPS Consumed % for ${vmname}",
                      "titleKind": 2,
                      "visualization": {
                        "axisVisualization": {
                          "x": {
                            "axisType": 2,
                            "isVisible": true
                          },
                          "y": {
                            "axisType": 1,
                            "isVisible": true
                          }
                        },
                        "chartType": 2,
                        "disablePinning": true,
                        "legendVisualization": {
                          "hideSubtitle": false,
                          "isVisible": true,
                          "position": 2
                        }
                      }
                    }
                  }
                }
              }
            }
          },
          "3": {
            "position": {
              "x": 6,
              "y": 3,
              "colSpan": 6,
              "rowSpan": 3
            },
            "metadata": {
              "inputs": [
                {
                  "name": "options",
                  "isOptional": true
                },
                {
                  "name": "sharedTimeRange",
                  "isOptional": true
                }
              ],
              "type": "Extension/HubsExtension/PartType/MonitorChartPart",
              "settings": {
                "content": {
                  "options": {
                    "chart": {
                      "metrics": [
                        {
                          "aggregationType": 4,
                          "metricVisualization": {
                            "displayName": "OS Disk Read Operations/Sec (Preview)",
                            "resourceDisplayName": "${vmname}"
                          },
                          "name": "OS Disk Read Operations/Sec",
                          "namespace": "microsoft.compute/virtualmachines",
                          "resourceMetadata": {
                            "id": "${vmid}"
                          }
                        },
                        {
                          "aggregationType": 4,
                          "metricVisualization": {
                            "displayName": "OS Disk Write Operations/Sec (Preview)",
                            "resourceDisplayName": "${vmname}"
                          },
                          "name": "OS Disk Write Operations/Sec",
                          "namespace": "microsoft.compute/virtualmachines",
                          "resourceMetadata": {
                            "id": "${vmid}"
                          }
                        }
                      ],
                      "title": "OS Disk Read Ops, Write Ops for ${vmname}",
                      "titleKind": 2,
                      "visualization": {
                        "axisVisualization": {
                          "x": {
                            "axisType": 2,
                            "isVisible": true
                          },
                          "y": {
                            "axisType": 1,
                            "isVisible": true
                          }
                        },
                        "chartType": 2,
                        "disablePinning": true,
                        "legendVisualization": {
                          "hideSubtitle": false,
                          "isVisible": true,
                          "position": 2
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    },
    "metadata": {
      "model": {
        "timeRange": {
          "value": {
            "relative": {
              "duration": 24,
              "timeUnit": 1
            }
          },
          "type": "MsPortalFx.Composition.Configuration.ValueTypes.TimeRange"
        },
        "filterLocale": {
          "value": "pl-pl"
        },
        "filters": {
          "value": {
            "MsPortalFx_TimeRange": {
              "model": {
                "format": "utc",
                "granularity": "auto",
                "relative": "30m"
              },
              "displayCache": {
                "name": "Czas UTC",
                "value": "Ostatnie 30 minut"
              },
              "filteredPartIds": [
                "StartboardPart-MonitorChartPart-9323435e-b2e5-4369-b021-2067ae5ee11b",
                "StartboardPart-MonitorChartPart-9323435e-b2e5-4369-b021-2067ae5ee11d",
                "StartboardPart-MonitorChartPart-9323435e-b2e5-4369-b021-2067ae5ee11f",
                "StartboardPart-MonitorChartPart-9323435e-b2e5-4369-b021-2067ae5ee121"
              ]
            }
          }
        }
      }
    }
  }
