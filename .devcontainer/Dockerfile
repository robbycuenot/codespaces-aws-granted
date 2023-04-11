FROM mcr.microsoft.com/devcontainers/universal:2

RUN \
    # Install Granted CLI \
    curl -OL releases.commonfate.io/granted/v0.9.1/granted_0.9.1_linux_x86_64.tar.gz \
    && sudo tar -zxvf ./granted_0.9.1_linux_x86_64.tar.gz -C /usr/local/bin/ \
    
    # Enable granted assume command
    && echo 'alias assume="source assume"' >> /home/codespace/.bashrc \
    && echo 'alias assume="source assume"' >> /home/codespace/.profile \
    
    # Enable AWS CLI autocompletion in Bash
    && echo "complete -C aws_completer aws" >> /home/codespace/.bashrc \
    && echo "complete -C aws_completer aws" >> /home/codespace/.profile \
    
    # Change ownership to the codespace user
    && chown codespace:codespace /home/codespace/.bashrc /home/codespace/.profile
