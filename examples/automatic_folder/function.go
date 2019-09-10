package function

//noinspection GoUnusedImport,GoInvalidPackageImport
import (
	"github.com/otiai10/copy"
	"github.com/hashicorp/terraform"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
	"path"
)

func copy_terraform_code(dirSource string, dirTarget string) (err error) {
	var objects []os.FileInfo
	if objects, err = ioutil.ReadDir(dirSource); err != nil {
		return err
	}

	for _, obj := range objects {
		name := obj.Name()

		switch name {
		case ".":
		case "..":
		case "credentials.json":
		case ".terraform":
			continue;
		case "provider.tf.dist":
			name = "provider.tf"
		}

		if err = copy.Copy(path.Join(dirSource, name), path.Join(dirTarget, name)); err != nil {
			return err
		}
	}

	return nil
}

func init_folder(dirSource string) (dirTarget string, err error) {
	if dirTarget, err = ioutil.TempDir("/tmp", "project"); err != nil {
		log.Panic(err)
	}

	if err = copy_terraform_code(dirSource, dirTarget); err != nil {
		log.Panic(err)
	}

	return dirTarget, err
}

func run_terraform(arg ...string) (err error) {
	cmd := exec.Command("terraform", "init")
	if err := cmd.Run(); err != nil {
		log.Fatal(err)
	}

	log.Print(cmd.CombinedOutput())

	return nil
}

func handler() (err error) {
	var dirSource string
	if dirSource, err = os.Getwd(); err != nil {
		log.Panic(err)
	}

	var dirTarget string
	if dirTarget, err = init_folder(dirSource); err != nil {
		log.Panic(err)
	}

	defer func() {
		err2 := os.RemoveAll(dirTarget)
		if (err2 != nil) {
			if (err == nil) {
				log.Panic(err2)
			}
			log.Print(err2)
		}
	}()

	var args []string
	const TF_PLAN = "tfplan"

	args = []string{"init", "-no-color", "-lock-timeout=300s"}
	if err = run_terraform(args...); err != nil {
		log.Panic(err)
	}

	args = []string{"plan", "-no-color", "-lock-timeout=300s", "-var-file=local.tfvars", "-out", TF_PLAN}
	if err = run_terraform(args...); err != nil {
		log.Panic(err)
	}

	args = []string{"plan", "-no-color", "-lock-timeout=300s", "-auto-approve", "-out", TF_PLAN}
	if err = run_terraform(args...); err != nil {
		log.Panic(err)
	}

	args = []string{"output", "-json"}
	if err = run_terraform(args...); err != nil {
		log.Panic(err)
	}

	return nil
}
