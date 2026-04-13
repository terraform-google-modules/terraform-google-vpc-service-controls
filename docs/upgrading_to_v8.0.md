# Upgrading to v8.x

The `regular_service_perimeter` module no longer sets `create_before_destroy = true` on ingress and egress policy resources.

This change is required because Access Context Manager enforces unique policy titles within a perimeter. Some ingress and egress policy changes force replacement, and `create_before_destroy` could cause applies to fail with:

```text
Error 400: Ingress and Egress rules titles must be unique within a perimeter.
```

No state migration is required.

However, future ingress and egress policy replacements will now be applied as destroy-then-create instead of create-then-destroy. If a temporary gap during replacement is unacceptable, plan the change for a maintenance window or use a different policy title for the replacement.
