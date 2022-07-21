output "cluster_id" {
  value       = join("", aws_emr_cluster.default.*.id)
  description = "EMR cluster ID"
}

output "cluster_name" {
  value       = join("", aws_emr_cluster.default.*.name)
  description = "EMR cluster name"
}