provider "google" {
  credentials = "${file("devops-233521-4a519c6ede87.json")}"
  project     = "devops-233521"
  region      = "us-central1"
  zone        = "us-central1-c"
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7"
    }
  }
  
  network_interface {
    # A default network is created for all GCP projects
    network       = "default"
    access_config = {
    }
  }
   metadata_startup_script = <<SCRIPT
sudo yum -y install wget
sudo rpm -ivh https://d2znqt9b1bc64u.cloudfront.net/java-1.8.0-amazon-corretto-devel-1.8.0_202.b08-2.x86_64.rpm
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum -y install jenkins java
sudo systemctl start jenkins
sudo yum -y install ansible
sudo wget http://apache.volia.net/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz
sudo tar xzvf apache-maven-3.6.0-bin.tar.gz
export PATH=~/apache-maven-3.6.0/bin:$PATH
SCRIPT
}
