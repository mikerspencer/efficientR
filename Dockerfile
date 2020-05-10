FROM rocker/tidyverse

# Other dependencies
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
	  libjpeg-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install other R packages
RUN R -e "remotes::install_github('csgillespie/efficientR')"
RUN su rstudio && \
  cd /home/rstudio && \
  wget https://github.com/csgillespie/efficientR/archive/master.zip && \
  unzip master.zip && \
  mv efficientR-master /home/rstudio/efficientR && \
  cd efficientR && \
  make html
RUN chown -Rv rstudio /home/rstudio/efficientR

# Install RStudio
RUN wget https://s3.amazonaws.com/rstudio-ide-build/server/bionic/amd64/rstudio-server-1.3.938-amd64.deb
RUN dpkg -i rstudio-server-*-amd64.deb && \
  rm rstudio-server-*-amd64.deb

RUN echo '{' >> /etc/rstudio/rstudio-prefs.json
RUN echo '    "rmd_chunk_output_inline": false' >> /etc/rstudio/rstudio-prefs.json
RUN echo '}' >> /etc/rstudio/rstudio-prefs.json
