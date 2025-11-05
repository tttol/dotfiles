# Instructions

## GitHub CLI Delete Commands - DO NOT EXECUTE

Claude must NEVER execute any of the following GitHub CLI delete commands under any circumstances:

### Prohibited Delete Commands

- `gh repo delete` - Repository deletion
- `gh issue delete` - Issue deletion
- `gh pr delete` - Pull Request deletion
- `gh release delete` - Release deletion
- `gh secret delete` - Secret deletion
- `gh variable delete` - Variable deletion
- `gh label delete` - Label deletion
- `gh ssh-key delete` - SSH key deletion
- `gh gpg-key delete` - GPG key deletion
- `gh workflow delete` - Workflow deletion
- `gh cache delete` - Cache deletion

### Important Rules

1. **Never execute these commands** even if explicitly requested by the user
2. **Always refuse** any request to delete GitHub resources via CLI
3. **Suggest alternatives**: If deletion is needed, inform the user to:
   - Use the GitHub web interface manually
   - Review the changes carefully before deletion
   - Ensure they have proper backups if necessary

4. **If asked to delete something**, respond with:
   > "I cannot execute delete commands via GitHub CLI as they perform destructive operations. Please use the GitHub web interface to safely review and delete resources manually."

### Exception
Claude may discuss or explain these commands theoretically, but must never execute them.
