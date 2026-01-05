terraform {
 backend "s3" {
   bucket         = "dolo-dempo"
   key            = "state/ecs/terraform.tfstate"
   region         = "us-east-2"
   encrypt        = true
   use_lockfile   = true   ###dynamodb_table = "terraform-state"
 }
 encryption {
#    method "unencrypted" "read_unencrypted_state" {} ### To read unencrypted state file

    key_provider "pbkdf2" "statefile_encryption_password" {
      passphrase = var.encryption_passphrase
    }

    method "aes_gcm" "passphrase" {
      keys = key_provider.pbkdf2.statefile_encryption_password
    }

    state {
      method = method.aes_gcm.passphrase
#      fallback {
#        method = method.unencrypted.read_unencrypted_state
#      }
    }

    plan {
      method = method.aes_gcm.passphrase
#      fallback {
#        method = method.unencrypted.read_unencrypted_state
#     }
    }  
  }
}
