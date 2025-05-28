<!-- markdownlint-disable MD033 -->
<!-- markdownlint-disable MD045 -->
<!-- markdownlint-disable MD041 -->

  <tr>
    <td><img src="https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fcdn.icon-icons.com%2Ficons2%2F2699%2FPNG%2F512%2Flinux_logo_icon_171222.png&f=1&nofb=1&ipt=7b969f2234f747e1db21294a093082793cd402f722f9a867d58226223e3cfc1c" width="800" /></td>
  </tr>
</table>


# Azure Resource Tagger

This Bash script applies tags to a list of Azure resources based on their IDs.

## 📋 Prerequisites

- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) installed and authenticated (`az login`)
- Proper permissions on the subscription to modify resource tags
- Environment variable `AZ_SUB_ID` set with your subscription ID:

  ```bash
  export AZ_SUB_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  ```

- A `resources.txt` file containing the full resource IDs (one per line), example:

  ```bash
  /subscriptions/<subscription-id>/resourceGroups/my-rg/providers/Microsoft.Compute/virtualMachines/my-vm
  ```

## 🚀 How to Use

1. Export your subscription ID as an environment variable:

   ```bash
   export AZ_SUB_ID="xxxxx-xxx-xxx-xxxx-XXXXXX"
   ```

2. Ensure `resources.txt` is in the same directory with correct IDs.

3. Run the script:

   ```bash
   bash tag.sh
   ```

## 🛠️ What the Script Does

- Reads the resources listed in `resources.txt`
- Trims line breaks and unnecessary spaces
- Applies the following set of tags to each resource:

  ```bash
  status=emuso
  env=prd
  produto=produto
  cliente=cliente
  iac=nao
  ```

## ⚠️ Notes

- Resources that cannot be tagged (such as deallocated VM extensions) will generate an error message, but the script will continue:

  ```bash
  ❌ Failed to tag: <resource-id>
  ```

- Blank or malformed lines will be ignored.
- The script uses `az tag update --operation merge`, which preserves existing tags and adds/updates the ones provided.

## 📁 Expected Structure

```bash
.
├── tag.sh           # Bash script
└── resources.txt    # List of resource IDs
```

## ✅ Example Output

```bash
Tagging: /subscriptions/xxx/resourceGroups/my-rg/providers/Microsoft.Compute/virtualMachines/vm01
{
  "id": "...",
  "tags": {
    "cliente": "client",
    "env": "prd",
    "iac": "nao",
    "produto": "produto",
    "status": "emuso"
  }
},
```

📥 Handy Tip: Generating the Resource ID List

If you want to automatically generate a list of resource IDs in your subscription:

```bash
az resource list \
  --query "[].{Name:name, Type:type, Location:location, ResourceGroup:resourceGroup, Tags:tags, Id:id}" \
  -o json > resources.json

jq -r '.[] | [.Name, .Type, .Location, .ResourceGroup, (.Tags | tostring), .Id] | @csv' resources.json > resources.csv

tail -n +2 resources.csv | awk -F',' '{gsub(/"/, "", $NF); print $NF}' > resources.txt # Adjust resources.txt if necessary
```
