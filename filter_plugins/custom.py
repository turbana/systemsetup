from ansible.plugins.filter.core import FilterModule

def auth_enabled(a, *args, **kwargs):
    service = dict(a)
    has_path = service.get("path", False)
    wants_auth = service.get("auth", {"enabled": True}).get("enabled", True)
    return has_path and wants_auth


class FilterModule(FilterModule):
    def filters(self):
        return {
            "auth_enabled": auth_enabled,
        }
