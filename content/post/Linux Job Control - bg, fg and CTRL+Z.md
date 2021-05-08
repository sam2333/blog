---
title: "Linux Job Control - bg, fg and CTRL+Z"
date: 2015-04-19T15:13:25+08:00
draft: false
tags:
  - "Linux"
categories:
  - "HowTo"
summary: "A job is a process that the shell manages. Each job is assigned a sequential job ID. Because a job is a process, each job has an associated PID."
---

# What's a job in Linux

A job is a process that the shell manages. Each job is assigned a sequential job ID.
Because a job is a process, each job has an associated PID. There are three types of job statuses:
1. **Foreground**: When you enter a command in a terminal window, the command occupies that terminal window until it completes. This is a foreground job.
2. **Background**: When you enter an ampersand (&) symbol at the end of a command line, the command runs without occupying the terminal window. The shell prompt is displayed immediately after you press Return. This is an example of a background job.
3. **Stopped**: If you press `Control + Z` for a foreground job, or enter the stop command for a background job, the job stops. This job is being called a stopped job.

> Note: Except the Bourne shell, the other shells support job control.

# Job Control Commands

Job control commands enable you to place jobs in the foreground or background, and to start or stop jobs. The table describes the job control commands.

| Option | Description |
| -- | -- |
| jobs | Lists all jobs |
| bg %n | Places the current or specified job in the background, where n is the job ID |
| fg %n | Brings the current or specified job into the foreground, where n is the job ID |
| Control-Z | Stops the foreground job and places it in the background as a stopped job |

> Note: The job control commands enable you to run and manage multiple jobs within a shell. However, you can use the job control commands only in the shell where the job was initiated.

# A Practical Example

-  Executing a background job

    ```
    > ping www.samsuse.com >/dev/null &
    [1] 4687
    ```

- View all the background jobs

    ```
    > jobs
    [1]  + running    ping www.samsuse.com > /dev/null
    ```

- Taking a job from the background to the foreground `fg %job_number`

    ```
    > fg %1
    [1]  + running    ping www.samsuse.com > /dev/null
    # ctrl+z
    > jobs
    [1]  + suspended  ping www.samsuse.com > /dev/null
    ```

- Continue running a suspended job in the background `bg %job_number`

    ```
    > bg %1
    [1]  + continued  ping www.samsuse.com > /dev/null
    ```

- Kill a running job using `kill %job_number`

    ```
    > kill %1
    [1]  + terminated  ping www.samsuse.com > /dev/null
    ```

![Linux Job Control - bg, fg and CTRL+Z](/images/linux-jobs.png)

# See also

[Understanding the job control commands in Linux – bg, fg and CTRL+Z](https://www.thegeekdiary.com/understanding-the-job-control-commands-in-linux-bg-fg-and-ctrlz/)
