# SDV Pipeline for Lilypad and Docker 🐋
Based on ComfyUI, the SDV Pipeline modules for Lilypad allow you generate videos from text prompts on Lilypad using Stable Diffusion Video and related models.

The SDV Pipeline modules are designed to take your text prompt, generate a still frame using SDXL, then use that as the input to the SDV model, producing an APNG (animated PNG), WebP video, and an MP4 video all in one go.

# Usage
These modules are designed to be run in a Docker container, either through the Lilypad Network or in Docker directly.

## Options and tunables
The following tunables are available. All of them are optional, and have default settings that will be used if you do not provide them.

| Name | Description | Default | Available options |
|------|-------------|---------|-------------------|
| `Prompt` | A text prompt for the model | "question mark floating in space" | Any string |
| `Framerate` | The framerate of the video | 8 | Any valid positive integer between 1 and 20 |
| `Seed` | A seed for the image model | 42 | Any valid non-negative integer |
| `Steps` | The number of steps to run the model for | 50 | Any valid non-negative integer from 5 to 200 inclusive |
| `Scheduler` | The scheduler to use for the model | `normal` | `normal`, `karras`, `exponential`, `sgm_uniform`, `simple`, `ddim_uniform` |
| `Sampler` | The sampler to use for the model | `euler_ancestral` |  `"euler"`, `"euler_ancestral"`, `"heun"`, `"heunpp2"`, `"dpm_2"`, `"dpm_2_ancestral"`, `"lms"`, `"dpm_fast"`, `"dpm_adaptive"`, `"dpmpp_2s_ancestral"`, `"dpmpp_sde"`, `"dpmpp_sde_gpu"`, `"dpmpp_2m"`, `"dpmpp_2m_sde"`, `"dpmpp_2m_sde_gpu"`, `"dpmpp_3m_sde"`, `"dpmpp_3m_sde_gpu"`, `"ddpm"`, `"lcm"` |
| `Batching` | How many images to produce | `1` | `1`, `2`, `4`, `8` |
| `VideoSeed` | A seed for the video model | 42 | Any valid non-negative integer |
| `VideoSteps` | The number of steps to run the video model for | 50 | Any valid non-negative integer from 5 to 70 inclusive |
| `VideoScheduler` | The scheduler to use for the video model | `normal` | `normal`, `karras`, `exponential`, `sgm_uniform`, `simple`, `ddim_uniform` |
| `VideoSampler` | The sampler to use for the video model | `euler_ancestral` |  `"euler"`, `"euler_ancestral"`, `"heun"`, `"heunpp2"`, `"dpm_2"`, `"dpm_2_ancestral"`, `"lms"`, `"dpm_fast"`, `"dpm_adaptive"`, `"dpmpp_2s_ancestral"`, `"dpmpp_sde"`, `"dpmpp_sde_gpu"`, `"dpmpp_2m"`, `"dpmpp_2m_sde"`, `"dpmpp_2m_sde_gpu"`, `"dpmpp_3m_sde"`, `"dpmpp_3m_sde_gpu"`, `"ddpm"`, `"lcm"` |

See the usage sections for the runner of your choice for more information on how to set and use these variables.

## Lilypad
To run SDV Pipeline in Lilypad, you can use the following commands:

### SDV 1.0
```bash
lilypad run sdv-pipeline:v1.0-lilypad2 -i ImageSeed="696721260153400" -i Prompt="an astronaut floating against a white background" -i Steps=200 -i VideoSteps 70
```

### SDV 1.1
```bash
lilypad run sdv-pipeline:v1.1-lilypad2 -i ImageSeed="696721260153400" -i Prompt="an astronaut floating against a white background" -i Steps=200 -i VideoSteps 70
```

### Specifying tunables

If you wish to specify more than one tunable, such as the number of steps, simply add more `-i` flags, like so:

```bash
lilypad run sdv-pipeline -i Prompt="an astronaut floating against a white background" -i Steps=69 -i VideoSteps 70
```

See the options and tunables section for more information on what tunables are available.

## Docker

To run these modules in Docker, you can use the following commands:

### SDV 1.0

```bash
docker run -ti --gpus all \
    -v $PWD/outputs:/outputs \
    -e PROMPT="an astronaut floating against a white background" \
    -e STEPS=50 -e VIDEOSTEPS=70 \
    zorlin/sdv:v1.0-lilypad2
```

### SDV v1.0

```bash
docker run -ti --gpus all \
    -v $PWD/outputs:/outputs \
    -e PROMPT="an astronaut floating against a white background" \
    -e STEPS=50 \
    zorlin/sdv:v1.0-lilypad2
```

### Specifying tunables
If you wish to specify more than one tunable, such as the number of steps, simply add more `-e` flags, like so:

```bash
-e PROMPT="an astronaut floating against a white background" \
-e STEPS=69 \
-e VIDEOSTEPS=70 \
```

See the options and tunables section for more information on what tunables are available.

# Development
You can build the Docker containers that form this module by following these steps (replacing Dockerfile-sdxl-0.9-refiner and its Git tags with the appropriate Dockerfile and tags for the model you wish to use):

```
export HUGGINGFACE_TOKEN=<my huggingface token>
```
```
# From the root directory of this repository, change to the docker folder.
cd docker
# Build the docker image
DOCKER_BUILDKIT=1 docker build -f Dockerfile-sdv-1.0 -t zorlin/sdv:v1.0-lilypad2 --target runner --build-arg HUGGINGFACE_TOKEN=$HUGGINGFACE_TOKEN .
```
```
mkdir -p outputs
```

# Publishing for production
To publish all of the images, run `scripts/build.sh`. Once you're satisfied, run `release.sh`.

Make sure to set the `HUGGINGFACE_TOKEN` environment variable to your **read only** Hugging Face token before running the scripts.

# Testing
Fork this repository and make your changes. Then, build a Docker container and run the module with your changes locally to test them out.

Once you've made your changes, publish your Docker image, then edit `lilypad_module.json.tmpl` to point at it and create a Git tag such as `v0.9-lilypad10`.

You can then run your module with 

`lilypad run github.com/zorlin/example:v0.1.2 -i Prompt="A very awesome dragon riding a unicorn"` to test your changes, replacing `zorlin` with your username and `v0.1.2` with the tag you created.

Note that most nodes on the public Lilypad network will be unlikely to run your module (due to allowlisting), so you may need to run a Lilypad node to test your changes. Once your module is stable and tested, you can request that it be adopted as an official module. Alternatively, if you're simply making changes to this module instead of making a new one, feel free to submit a pull request.

# Credits
Authored by the Lilypad team. Maintained by [Zorlin](https://github.com/Zorlin).

Based on [lilypad-sdxl](https://github.com/lilypad-tech/lilypad-sdxl-module), which was written by early Lilypad contributors.

Based on ComfyUI.

With thanks and a hat tip to https://medium.com/@yushantripleseven/comfyui-using-the-api-261293aa055a for great API examples and the basis of our wrapper/API script. entrypoint.sh loosely based on [basic_workflow_api.py by yushan777](https://gist.github.com/yushan777/1e31e06c088550611f3a0b91ba150975).
